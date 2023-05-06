from sqlmodel import Session, select
from geopy.distance import geodesic as distance
from fastapi.websockets import WebSocketState, WebSocket

from db import Emergency, User, Provider, Responder, EmergencyStatus, ResponderEmergencyLink
from routes.web.provider.websocket import provider_connections

class ServerEmergency:
  
  def id_equals(self, id: int):
    return self.__emergency.id == id
  
  def has_responder(self, responder: Responder):
    if self.__responder is None:
      return False
    return responder.id == self.__responder.id

  def __init__(self, user: User, user_ws: WebSocket, lat: float, lng: float) -> None:
    # __user: User
    # __user_ws_channel: WebSocket

    # __provider: Provider
    # __provider_ws_channel: WebSocket
    
    # __responder: Responder

    # __emergency: Emergency
    # __session: Session
    
    self.__user = user
    self.__user_ws_channel = user_ws

    self.__responder = None

    self.__session: Session = Session.object_session(self.__user)
    
    self.__emergency = Emergency(
      status=EmergencyStatus.WAITING,
      locationLat=lat,
      locationLng=lng,
      user=user
    )

    self.__session.add(self.__emergency)
    self.__session.commit()

  async def async_init(self):
    closest = None
    closest_km = 250000 # TODO change this to 250 or sth

    user_pos = self.__emergency.locationLat, self.__emergency.locationLng

    for provider in provider_connections:
      provider_pos = provider.provider.locationLat, provider.provider.locationLng

      current = distance(user_pos, provider_pos).km
      print(current)
      if (current < closest_km):
        closest = provider
        closest_km = current

    if closest is None:
      await self.reject()
      return False

    await closest.ws.send_json({
      "type": "emergency",
      "emergency": self.__emergency.dict(exclude={"time"})
    })

    return True
  

  async def reject(self):
    self.__emergency.status = EmergencyStatus.REJECTED
    self.__session.add(self.__emergency)
    self.__session.commit()
    self.__session.close()

    if self.__user_ws_channel.application_state == WebSocketState.DISCONNECTED:
      return

    await self.__user_ws_channel.send_json({
      "status": EmergencyStatus.REJECTED,
      "message": "Emergency request was rejected!",
    })
    await self.__user_ws_channel.close()
  
  async def accept(self, responder_id: int):
    self.__emergency.status = EmergencyStatus.SENT

    statement = select(Responder).where(Responder.id == responder_id)
    self.__responder = self.__session.exec(statement).one()
    
    link = ResponderEmergencyLink(
      emergency=self.__emergency,
      responder=self.__responder,
      responder_type=self.__responder.provider.provider_type
    )
    
    self.__session.add(self.__emergency)
    self.__session.add(link)
    self.__session.commit()

    await self.__user_ws_channel.send_json({
      "status": EmergencyStatus.SENT,
      "responder": {
        "name": self.__responder.name,
        "provider_name": self.__responder.provider.name,
        "phone": self.__responder.phone,
        "lat": self.__responder.last_lat,
        "lng": self.__responder.last_lng,
      }
    })

  async def update_responder_pos(self, responder: Responder):
    print("TEST PRINT")
    print(self.__emergency.locationLat)
    print("TEST PRINT")


    self.__session.merge(responder)
    self.__session.commit()
    
    await self.__user_ws_channel.send_json({
      "responder_pos": {
        "id": responder.id,
        "lat": responder.last_lat,
        "lng": responder.last_lng
      }
    })
  
  def get_summary(self):
    e = self.__emergency

    return {
      "id": e.id,
      "lat": e.locationLat,
      "lng": e.locationLng,
      "user": {
        "name": e.user.name,
        "phone": e.user.phone,
      },
    }

  async def resolve(self):
    self.__emergency.status = EmergencyStatus.RESOLVED
    self.__session.add(self.__emergency)
    self.__session.commit()
    self.__session.close()

    if self.__user_ws_channel.application_state == WebSocketState.DISCONNECTED:
      return
    
    await self.__user_ws_channel.send_json({
      "status": EmergencyStatus.RESOLVED,
    })
    await self.__user_ws_channel.close()


from emergency.manager import EmergencyManager
manager = EmergencyManager()
