from typing import Annotated
from sqlmodel import Session, select
from fastapi import APIRouter, Depends
from pydantic import constr, EmailStr, BaseModel

from db import engine, User
from routes.user_app.depends import get_user
from utils.crypt import gen_token, pw_context
from utils.exceptions import CredentialsException
from utils.types import PasswordStr, PhoneStr

router = APIRouter()


def user_with_token(user: User, token: str):
  return {
    "name": user.name,
    "email": user.email,
    "phone": user.phone,
    "token": token,
    "dateOfBirth": user.dateOfBirth,
    "blood": user.blood,
    "docID": user.docID,
    "address": user.address,
    "docType": user.docType
  }

class SignUpDetails(BaseModel):
  name: constr(max_length=50)
  email: EmailStr
  phone: PhoneStr
  password: PasswordStr
  address: str
  dateOfBirth: str
  docType: str
  docID: str
  blood: str

@router.post("/signup")
def signup_user(info: SignUpDetails):
  pw_hash = pw_context.hash(info.password)
  token, token_hash = gen_token()

  session = Session(engine)  
  user = User(
    name=info.name,
    email=info.email,
    phone=info.phone,
    hashed_password=pw_hash,
    address=info.address,
    dateOfBirth=info.dateOfBirth,
    docType=info.docType,
    docID=info.docID,
    blood=info.blood,
    hashed_token=token_hash
  )
  session.add(user)
  session.commit()

  return user_with_token(user, token)


class LoginDetails(BaseModel):
  phone: PhoneStr
  password: PasswordStr

@router.post("/login")
def login_user(info: LoginDetails):
  session = Session(engine)
  statement = select(User).where(User.phone == info.phone)
  user = session.exec(statement).one_or_none()

  if (user is None):
    raise CredentialsException

  if not (pw_context.verify(info.password, user.hashed_password)):
    raise CredentialsException
  
  token, hashed_token = gen_token()

  # Update token in database
  user.hashed_token = hashed_token
  session.add(user)
  session.commit()

  return user_with_token(user, token)


@router.post("/logout")
def logout_user(user: Annotated[User, Depends(get_user)]):
  session = Session.object_session(user)
  user.hashed_token = None
  session.add(user)
  session.commit()
  return


@router.post("/getUser")
def get_user(user: Annotated[User, Depends(get_user)]):
  return user
