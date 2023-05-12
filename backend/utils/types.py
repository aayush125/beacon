from fastapi import File, Form, UploadFile
from typing import Annotated, Literal
from pydantic import constr

FormStr = Annotated[str, Form()]
FormInt = Annotated[int, Form()]
FormFloat = Annotated[float, Form()]
FormFile = Annotated[UploadFile, File()]
FormType = Annotated[Literal["fire", "medical", "police"], Form()]

PasswordStr = constr(min_length=3, max_length=16)
PhoneStr = constr(min_length=10, max_length=10)
