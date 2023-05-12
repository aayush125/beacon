from typing import List, Dict
from fastapi.websockets import WebSocket, WebSocketState
from sqlmodel import Session
from geopy.distance import geodesic as distance

from db import Emergency, EmergencyType, Provider, User, EmergencyStatus, ResponderEmergencyLink, Responder
from routes.web.provider.websocket import provider_connections
from routes.responder_app.endpoints import responder_connections, ConnectedResponder
from utils.age import calculate_age
from utils.websocket import is_connected

class TypedEmergency:
  def __init__(
    self,
    type: EmergencyType 
  ) -> None:
    self.type = type
    self.status = EmergencyStatus.WAITING
    self.responder_connection = None
    self.provider_connection = None

  async def reject(self):
    self.status = EmergencyStatus.REJECTED
    await self.cleanup()

  async def resolve(self):
    self.status = EmergencyStatus.RESOLVED
    await self.cleanup()

  async def cleanup(self):
    if self.status == EmergencyStatus.WAITING or self.status == EmergencyStatus.SENT:
      self.status = EmergencyStatus.REJECTED

    if self.responder_connection is not None:
      self.responder_connection.available = True
      self.responder_connection = None
    
    self.provider_connection = None

  async def assign_responder(self, connection: ConnectedResponder):
    connection.available = False
    self.responder_connection = connection

  async def find_provider(self, lat: float, lng: float):
    closest = None
    closest_km = 250000 # TODO change this to 250 or sth

    user_pos = lat, lng

    print("provider connections: ", provider_connections)

    for connection in provider_connections:
      if (connection.provider.provider_type != self.type):
        continue

      provider_pos = connection.provider.locationLat, connection.provider.locationLng

      current = distance(user_pos, provider_pos).km
      
      if (current < closest_km):
        closest = connection
        closest_km = current

    if closest is None:
      await self.reject()
      return None

    self.provider_connection = closest.ws

    return closest.ws


class ServerEmergency:
  def __init__(
    self,
    user: User,
    user_ws: WebSocket,
    lat: float,
    lng: float,
    types: List[EmergencyType]
  ) -> None:
    self.session = Session.object_session(user)
    
    self.user = user
    self.user_ws = user_ws    

    self.emergency = Emergency(
      status = EmergencyStatus.WAITING,
      locationLat=lat,
      locationLng=lng,
      user=user
    )

    self.session.add(self.emergency)
    self.session.commit()

    self.typed_emergencies: Dict[EmergencyType, TypedEmergency] = {}
    for t in types:
      self.typed_emergencies[t] = TypedEmergency(t)

  def get_id(self):
    return self.emergency.id
  
  def get_user_id(self):
    return self.user.id  

  async def find_providers(self):
    for e in self.typed_emergencies.values():
      provider_ws = await e.find_provider(self.emergency.locationLat, self.emergency.locationLng)

      if provider_ws is None:
        await self.user_ws.send_json({
          "type": "provider_update",
          "state": "rejected",
          "message": "Provider for " + e.type + " was not found."
        })
        continue
      
      age = calculate_age(self.user.dateOfBirth)
      
      # If provider was found, provide emergency info to the provider so they can accept or reject
      await provider_ws.send_json({
        "type": "emergency",
        "emergency": {
          "id": self.get_id(),
          "user": {
            "name": self.user.name,
            "phone": self.user.phone,
            "blood": self.user.blood,
            "age": age,
          },
          "lat": self.emergency.locationLat,
          "lng": self.emergency.locationLng,
        }
      })

  async def handle_reject_provider(self, name: str, e_type: EmergencyType):
    await self.typed_emergencies[e_type].reject()

    await self.user_ws.send_json({
      "type": "provider_update",
      "state": "rejected",
      "message": "Provider for " + e_type + " (" + name + ") rejected your request."
    })
  
  async def handle_resolve_responder(self, responder: Responder):
    for e in self.typed_emergencies.values():
      if e.responder_connection is None:
        continue
      
      if e.responder_connection.responder.id == responder.id:
        await self.user_ws.send_json({
          "type": "responder_update",
          "state": "resolved",
          "responder_id": responder.id,
        })

        if (is_connected(e.provider_connection)):
          await e.provider_connection.send_json({
            "type": "emergency_update",
              "emergency": {
                "id": self.emergency.id,
                "status": EmergencyStatus.RESOLVED
              }
          })

        await e.resolve()

  async def handle_reject_responder(self, responder: Responder):
    for e in self.typed_emergencies.values():
      if e.responder_connection is None:
        continue
      
      if e.responder_connection.responder.id == responder.id:
        
        await self.user_ws.send_json({
          "type": "responder_update",
          "state": "rejected",
          "responder_id": responder.id,
        })

        if (is_connected(e.provider_connection)):
          await e.provider_connection.send_json({
            "type": "emergency_update",
              "emergency": {
                "id": self.emergency.id,
                "status": EmergencyStatus.REJECTED
              }
          })
        
        await e.reject()


  async def is_complete(self):
    for e in self.typed_emergencies.values():
      if e.status == EmergencyStatus.SENT or e.status == EmergencyStatus.WAITING:
        return False
    return True
  
  async def update_responder_pos(self, responder_id: int, lat: float, lng: float):
    for e in self.typed_emergencies.values():
      if e.responder_connection is None:
        continue

      if e.responder_connection.responder.id == responder_id:
        await self.user_ws.send_json({
          "type": "responder_pos",
          "responder": {
            "id": responder_id,
            "lat": lat,
            "lng": lng,
          }
        })
        return True
    return False

  async def assign_responder(self, responder_id: int, e_type: EmergencyType):
    for c in responder_connections:
      if c.responder.id == responder_id:
        
        await self.typed_emergencies[e_type].assign_responder(c)
        
        self.emergency.status = EmergencyStatus.SENT
        self.session.add(self.emergency)
        r = self.session.merge(c.responder)
        link = ResponderEmergencyLink(emergency=self.emergency, responder=r, responder_type=e_type)
        self.emergency.responder_links.append(link)
        self.session.commit()

        e = self.emergency
        await c.ws.send_json({
          "type": "assigned",
          "id": e.id,
          "lat": e.locationLat,
          "lng": e.locationLng,
          "user": {
            "name": e.user.name,
            "phone": e.user.phone,
          },
        })        

        await self.user_ws.send_json({
          "type": "responder_assigned",
          "responder": {
            "id": c.responder.id,
            "name": c.responder.name,
            "phone": c.responder.phone,
            "type": e_type,
          }
        })

        return
      
  async def cleanup(self):
    state = EmergencyStatus.REJECTED

    for c in self.typed_emergencies.values():
      
      if c.provider_connection is not None:
        if is_connected(c.provider_connection):
          await c.provider_connection.send_json({
            "type": "emergency_update",
            "emergency": {
              "id": self.emergency.id,
              "status": EmergencyStatus.REJECTED
            }
          })
        
      await c.cleanup()
      
      if c.status == EmergencyStatus.RESOLVED:
        state = EmergencyStatus.RESOLVED

    self.emergency.status = state
    self.session.add(self.emergency)
    self.session.commit()


    if self.user_ws.application_state == WebSocketState.CONNECTED:
      await self.user_ws.send_json({
        "type": "emergency_end",
        "final_state": state
      })
      await self.user_ws.close()

    self.session.close()
