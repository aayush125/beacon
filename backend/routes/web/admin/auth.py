from fastapi import APIRouter, Depends
from fastapi.responses import Response

from utils.types import FormStr
from utils.crypt import gen_token
from utils.exceptions import CredentialsException
from routes.web.admin.depends import check_admin, set_hash

router = APIRouter()

@router.post("/login")
def login_admin(username: FormStr, password: FormStr):
  if not (username == "admin" and password == "admin"):
    raise CredentialsException

  res = Response()
  
  token, hashed_token = gen_token()

  res.set_cookie(
    key="admin_session",
    value=token,
    httponly=True,
    max_age=86400,
    samesite="strict"
  )

  set_hash(hashed_token)

  return res

@router.get("/is_logged_in")
def is_logged_in(admin = Depends(check_admin)):
  return

@router.post("/logout")
def logout_admin(admin = Depends(check_admin)):
  set_hash(None)

  res = Response()
  
  res.delete_cookie(
    key="admin_session",
    samesite="strict"
  )

  return res