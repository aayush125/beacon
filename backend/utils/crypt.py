from passlib import pwd
from hashlib import sha512
from passlib.context import CryptContext

pw_context = CryptContext(schemes=["bcrypt"])

def gen_token():
  token = pwd.genword(length=64)
  return token, hash_token(token)

def hash_token(token):
  return sha512(token.encode("utf-8")).hexdigest()
