from typing import Annotated, Literal
from fastapi import APIRouter, File, Form, UploadFile
from sqlmodel import Session
from db import engine, Provider
from cloudinary.uploader import upload

router = APIRouter(
  prefix="/web",
  tags=["web"]
)

FormStr = Annotated[str, Form()]
FormInt = Annotated[int, Form()]
FormFile = Annotated[UploadFile, File()]

@router.post("/provider/register")
def register_provider(
  name: FormStr,
  pan_no: FormInt,
  reg_no: FormStr,
  address: FormStr,
  contact_no: FormStr,
  email: FormStr,
  type: Annotated[Literal["fire", "medical", "police"], Form()],
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
    locationLat=0,
    locationLng=0,
    email=email,
    provider_type=type
  )
  session.add(provider)
  
  session.commit()

  upload(img_pan.file, public_id=f"{provider.id}_pan")
  upload(img_reg.file, public_id=f"{provider.id}_reg")
  upload(img_logo.file, public_id=f"{provider.id}_logo")

