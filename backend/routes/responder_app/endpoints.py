from dataclasses import dataclass
from typing import Annotated, List
from pydantic import BaseModel
from fastapi import APIRouter, Body, Depends, WebSocket, WebSocketDisconnect
from sqlmodel import Session

from db import Responder, engine
from time import time
from routes.responder_app.depends import get_responder_query

router = APIRouter()

@dataclass
class ConnectedResponder:
  responder: Responder
  ws: WebSocket
  available: bool = True

responder_connections: List[ConnectedResponder] = []

from routes.web.provider.websocket import provider_connections
from emergency import manager

@router.websocket("/ws")
async def responder_websocket(
  ws: WebSocket,
  responder: Annotated[Responder, Depends(get_responder_query)]
):
  await ws.accept()

  current = ConnectedResponder(responder=responder, ws=ws)
  responder_connections.append(current)

  try:
    while True:
      json = await ws.receive_json()

      if json["type"] == "pos_update":
        lat = json["lat"]
        lng = json["lng"]

        # If provider is connected, send position to provider too
        for connection in provider_connections:
          if responder.provider_id == connection.provider.id:
            await connection.ws.send_json({
              "type": "responder_pos_update",
              "responder": {
                "id": responder.id,
                "lat": lat,
                "lng": lng,
                "available": current.available
              }
            })
            break
        await manager.update_responder_pos(responder.id, lat, lng)
      elif json["type"] == "emergency_resolve":
        await manager.responder_resolve_emergency(json["emergency_id"], responder)
  except WebSocketDisconnect:
    # TODO send responder disconnected message to emergency and provider
    responder_connections.remove(current)
    

# @router.post("/ping")
# async def responder_ping(
#   lat: Annotated[float, Body()], 
#   lng: Annotated[float, Body()],
#   responder: Annotated[Responder, Depends(get_responder)]
# ):
#   responder.last_active_timestamp = time()
#   responder.last_lat = lat
#   responder.last_lng = lng
  
#   emergency = manager.get_emergency_from_responder(responder)

#   # If provider is connected, send position of responder to server
#   for connection in provider_connections:
#     if responder.provider_id == connection.provider.id:
#       await connection.ws.send_json({
#         "type": "responder_pos_update",
#         "responder": {
#           "id": responder.id,
#           "lat": responder.last_lat,
#           "lng": responder.last_lng,
#           "available": emergency is None
#         }
#       })
#       break

#   # Responder is not currently associated with any active emergency
#   if emergency is None:
#     session = Session.object_session(responder)
#     session.add(responder)
#     session.commit()
#     return None
  
#   # User will be informed of responder position as needed
#   await emergency.update_responder_pos(responder)
  
#   return emergency.get_summary()

# @router.post("/resolve_emergency")
# async def responder_resolve(
#   responder: Annotated[Responder, Depends(get_responder)]
# ):
#   emergency = manager.get_emergency_from_responder(responder)
#   if emergency is None:
#     return
  
#   await manager.resolve_emergency(emergency)
