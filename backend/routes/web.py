from typing import Annotated, Literal
from fastapi import APIRouter, File, Form, UploadFile
from db import init_db

init_db()

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
    print(name)
