from typing import Union
from fastapi import Cookie
from sqlmodel import Session, select
from db import engine, Provider
from utils.crypt import hash_token
from utils.exceptions import CredentialsException

def get_provider(token: Union[str, None] = Cookie(default=None, alias="provider_session")):
  if (token is None):
    raise CredentialsException
  
  session = Session(engine)
  statement = select(Provider).where(Provider.hashed_token == hash_token(token))
  user = session.exec(statement).one_or_none()

  if (user is None):
    raise CredentialsException

  return user
