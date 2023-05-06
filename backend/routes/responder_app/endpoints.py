from typing import Annotated
from pydantic import BaseModel
from fastapi import APIRouter, Body, Depends
from sqlmodel import Session

from db import Responder, engine
from time import time
from routes.responder_app.depends import get_responder
from emergency import manager
from routes.web.provider.websocket import provider_connections

router = APIRouter()

@router.post("/ping")
async def responder_ping(
  lat: Annotated[float, Body()], 
  lng: Annotated[float, Body()],
  responder: Annotated[Responder, Depends(get_responder)]
):
  responder.last_active_timestamp = time()
  responder.last_lat = lat
  responder.last_lng = lng
  
  emergency = manager.get_emergency_from_responder(responder)

  # If provider is connected, send position of responder to server
  for connection in provider_connections:
    if responder.provider_id == connection.provider.id:
      await connection.ws.send_json({
        "type": "responder_pos_update",
        "responder": {
          "id": responder.id,
          "lat": responder.last_lat,
          "lng": responder.last_lng,
          "available": emergency is None
        }
      })
      break

  # Responder is not currently associated with any active emergency
  if emergency is None:
    session = Session.object_session(responder)
    session.add(responder)
    session.commit()
    return None
  
  # User will be informed of responder position as needed
  await emergency.update_responder_pos(responder)
  
  return emergency.get_summary()

@router.post("/resolve_emergency")
async def responder_resolve(
  responder: Annotated[Responder, Depends(get_responder)]
):
  emergency = manager.get_emergency_from_responder(responder)
  if emergency is None:
    return
  
  await manager.resolve_emergency(emergency)
