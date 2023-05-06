from typing import Annotated
from fastapi import APIRouter, Depends
from sqlmodel import Session

from utils.types import FormStr
from routes.web.provider.depends import get_provider
from db import engine, Responder, Provider, EmergencyStatus
from utils.crypt import pw_context
from time import time

router = APIRouter()

def is_available(responder: Responder):
  min_limit = time() - 120

  if responder.last_active_timestamp < min_limit:
    return False
  
  for link in responder.emergency_links:
    if link.emergency.status == EmergencyStatus.SENT:
      return False
  
  return True


def responders_with_availibility(provider: Provider):
  ret = []

  for responder in provider.responders:
    entry = responder.dict()
    entry["available"] = is_available(responder)
    ret.append(entry)

  ret.sort(key = lambda r : r["available"])

  return ret


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
