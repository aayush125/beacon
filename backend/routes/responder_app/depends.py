from typing import Annotated
from fastapi import Body
from pydantic import constr
from sqlmodel import Session, select
from db import engine, Responder
from utils.crypt import hash_token

def get_responder(token: Annotated[constr(min_length=64, max_length=64), Body(embed=True)]):
  return __resolve_responder(token)

def get_responder_query(token: constr(min_length=64, max_length=64)):
  return __resolve_responder(token)

def __resolve_responder(token: str):
  session = Session(engine)
  statement = select(Responder).where(Responder.hashed_token == hash_token(token))
  responder = session.exec(statement).one() 
  return responder
