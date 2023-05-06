from typing import Annotated
from fastapi import Body
from pydantic import constr
from sqlmodel import Session, select
from db import engine, User
from utils.crypt import hash_token

def get_user(token: Annotated[constr(min_length=64, max_length=64), Body(embed=True)]):
  return __resolve_user(token)

def get_user_query(token: constr(min_length=64, max_length=64)):
  return __resolve_user(token)

def __resolve_user(token: str):
  session = Session(engine)
  statement = select(User).where(User.hashed_token == hash_token(token))
  user = session.exec(statement).one()
  return user
