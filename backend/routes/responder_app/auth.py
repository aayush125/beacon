from typing import Annotated
from fastapi import APIRouter, Depends
from pydantic import constr, EmailStr, BaseModel
from sqlmodel import Session, select

from db import engine, Responder
from utils.crypt import gen_token, pw_context
from utils.exceptions import CredentialsException
from utils.types import PhoneStr, PasswordStr
from routes.responder_app.depends import get_responder

router = APIRouter()

class LoginDetails(BaseModel):
  phone: PhoneStr
  password: PasswordStr

@router.post("/login")
def login_responder(info: LoginDetails):
  session = Session(engine)
  statement = select(Responder).where(Responder.phone == info.phone)
  responder = session.exec(statement).one_or_none()

  if (responder is None):
    raise CredentialsException

  if not (pw_context.verify(info.password, responder.hashed_password)):
    raise CredentialsException
  
  token, hashed_token = gen_token()

  # Update token in database
  responder.hashed_token = hashed_token
  session.add(responder)
  session.commit()

  return {
    "name": responder.name,
    "phone": responder.phone,
    "token": token,
    "provider_name": responder.provider.name,
  }


@router.post("/logout")
def logout_responder(responder: Annotated[Responder, Depends(get_responder)]):
  session = Session.object_session(responder)
  responder.hashed_token = None
  session.add(responder)
  session.commit()
  return


@router.post("/getResponder")
def get_responder(responder: Annotated[tuple[Responder, Session], Depends(get_responder)]):
  return {
    "name": responder.name,
    "phone": responder.phone,
    "provider_name": responder.provider.name
  }
