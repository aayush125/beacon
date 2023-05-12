from typing import Union
from fastapi import Cookie

from utils.exceptions import CredentialsException
from utils.crypt import hash_token

admin_hashed_token = None

def set_hash(hashed_token):
  global admin_hashed_token
  admin_hashed_token = hashed_token

def check_admin(token: Union[str, None] = Cookie(default=None, alias="admin_session")):
  if token is None:
    raise CredentialsException
  
  if admin_hashed_token == hash_token(token):
    return True
  
  raise CredentialsException
