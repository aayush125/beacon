from typing import Annotated, List
from fastapi import WebSocket, APIRouter, Depends, WebSocketDisconnect
from sqlmodel import Session

from db import Provider
from dataclasses import dataclass

@dataclass
class ConnectedProvider:
  provider: Provider
  ws: WebSocket

provider_connections: List[ConnectedProvider] = []

from routes.web.provider.depends import get_provider
from routes.web.provider.responder import responders_with_availibility
from emergency import manager

router = APIRouter()

@router.websocket("/ws")
async def provider_websocket(ws: WebSocket, provider: Annotated[Provider, Depends(get_provider)]):
  await ws.accept()

  session = Session.object_session(provider)

  # Send list of responders, and lat/lng of provider office
  await ws.send_json({
    "type": "initial",
    "responders": responders_with_availibility(provider),
    "location": {
      "lat": provider.locationLat,
      "lng": provider.locationLng,
    },
  })

  current = ConnectedProvider(provider=provider, ws=ws)
  provider_connections.append(current)
  try:
    while True:
      data = await ws.receive_json()
      
      # {
      #   "emergency_id": ..
      #   "accepted": true or false
      #   "responder_id": ..
      # }

      if not data["accepted"]:
        await manager.provider_reject_emergency(data["emergency_id"], provider.name, provider.provider_type)
      else:
        await manager.provider_accept_emergency(data["emergency_id"], data["responder_id"], provider.provider_type)
  except WebSocketDisconnect:
    print("Disconnected?")
    # TODO reject emergency on provider disconnect
    # await manager.provider_reject_emergency(data["emergency_id"], provider.name, provider.provider_type)
    provider_connections.remove(current)
