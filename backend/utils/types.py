from fastapi import File, Form, UploadFile
from typing import Annotated, Literal

FormStr = Annotated[str, Form()]
FormInt = Annotated[int, Form()]
FormFloat = Annotated[float, Form()]
FormFile = Annotated[UploadFile, File()]
FormType = Annotated[Literal["fire", "medical", "police"], Form()]
