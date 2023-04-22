from typing import Annotated
from fastapi import APIRouter, Body
from pydantic import constr, EmailStr, BaseModel

router = APIRouter(
  prefix="/app",
  tags=["app"]
)

PasswordStr = constr(min_length=3, max_length=16)
TokenBody = Annotated[constr(min_length=64, max_length=64), Body(embed=True)]

class SignUpDetails(BaseModel):
  name: constr(max_length=50)
  email: EmailStr
  phone: constr(min_length=10, max_length=10)
  password: PasswordStr

@router.post("/signup")
def signup(info: SignUpDetails):
  pass


class LoginDetails(BaseModel):
  email: EmailStr
  password: PasswordStr

@router.post("/login")
def login(info: LoginDetails):
  pass

@router.post("/logout")
def login(token: TokenBody):
  pass

@router.post("/getUser")
def getUser(token: TokenBody):
  pass
