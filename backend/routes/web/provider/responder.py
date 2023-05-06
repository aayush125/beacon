from typing import Annotated
from fastapi import APIRouter, Depends
from sqlmodel import Session
from time import time

from utils.types import FormStr
from routes.web.provider.depends import get_provider
from db import engine, Responder, Provider, EmergencyStatus
from utils.crypt import pw_context

router = APIRouter()

def is_available(responder: Responder):
  for conn in responder_connections:
    if conn.responder.id == responder.id:
      return conn.available
  return False

def responders_with_availibility(provider: Provider):
  ret = []

  for responder in provider.responders:
    entry = {
      "id": responder.id,
      "name": responder.name,
      "phone": responder.phone,
      "available": is_available(responder)
    }
    ret.append(entry)

  return ret

from routes.responder_app.endpoints import responder_connections

@router.post("/register_responder")
def register_responder(
  name: FormStr,
  phone: FormStr,
  password: FormStr,
  provider: Annotated[Provider, Depends(get_provider)]
):
  pw_hash = pw_context.hash(password)

  session = Session.object_session(provider)
  responder = Responder(
    name=name,
    phone=phone,
    hashed_password=pw_hash,
    provider=provider
  )
  session.add(responder)
  session.commit()

  return responders_with_availibility(provider)
