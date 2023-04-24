from fastapi import APIRouter
from sqlmodel import Session, select
from cloudinary.uploader import upload
from fastapi.responses import Response

from db import engine, Provider
from utils.crypt import gen_token, pw_context
from utils.exceptions import CredentialsException
from utils.types import FormStr, FormInt, FormFloat, FormFile, FormType

router = APIRouter()

@router.post("/register")
def register_provider(
  name: FormStr,
  pan_no: FormInt,
  reg_no: FormStr,
  address: FormStr,
  contact_no: FormStr,
  locationLat: FormFloat,
  locationLng: FormFloat,
  email: FormStr,
  type: FormType,
  img_pan: FormFile,
  img_reg: FormFile,
  img_logo: FormFile 
):
  session = Session(engine)

  provider = Provider(
    name=name,
    approved=False,
    pan_no=pan_no,
    reg_no=reg_no,
    address=address,
    contact_no=contact_no,
    locationLat=locationLat,
    locationLng=locationLng,
    email=email,
    provider_type=type
  )
  session.add(provider)
  
  session.commit()

  upload(img_pan.file, public_id=f"{provider.id}_pan")
  upload(img_reg.file, public_id=f"{provider.id}_reg")
  upload(img_logo.file, public_id=f"{provider.id}_logo")


@router.post("/login")
def login_provider(username: FormStr, password: FormStr):
  session = Session(engine)
  statement = select(Provider).where(Provider.username == username)
  provider = session.exec(statement).one_or_none()

  if (provider is None):
    raise CredentialsException

  if not (provider.approved):
    raise CredentialsException
  
  if not (pw_context.verify(password, provider.hashed_password)):
    raise CredentialsException
  
  res = Response()
  
  token, hashed_token = gen_token()
  
  res.set_cookie(
    key="provider_session",
    value=token,
    httponly=True,
    max_age=7*86400,
    samesite="strict"
  )

  provider.hashed_token = hashed_token

  session.add(provider)
  session.commit()

  return res
