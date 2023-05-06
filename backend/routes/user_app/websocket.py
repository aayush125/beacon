from typing import Annotated, List
from fastapi import APIRouter, Depends, WebSocket, WebSocketDisconnect, Query
from pydantic import constr, EmailStr, BaseModel
from sqlmodel import Session, select

from db import engine, User, Emergency, EmergencyStatus, EmergencyType
from utils.crypt import gen_token, pw_context
from utils.exceptions import CredentialsException
from routes.user_app.depends import get_user, get_user_query
from emergency import manager, ServerEmergency

router = APIRouter(
  prefix="/emergency"
)

class EmergencyDetails(BaseModel):
  lat: float
  lng: float

@router.websocket("/ws")
async def user_websocket(
  ws: WebSocket,
  lat: float,
  lng: float,
  type: Annotated[List[EmergencyType], Query()],
  user: Annotated[User, Depends(get_user_query)]
):
  await ws.accept()
  emergency = ServerEmergency(user, ws, lat, lng)
  res = await manager.add_emergency(emergency)

  if not res:
    return

  try:
    while True:
      await ws.receive_json()
  except WebSocketDisconnect:
    await manager.remove_emergency(emergency)
