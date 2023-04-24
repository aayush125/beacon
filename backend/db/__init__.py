from typing import Literal, Optional
from sqlmodel import Field, SQLModel, create_engine

class Provider(SQLModel, table = True):
  id: int = Field(primary_key = True)
  name: str
  approved: bool
  pan_no: int = Field(unique = True)
  reg_no: str = Field(unique = True)
  address: str
  locationLat: float
  locationLng: float
  contact_no: str
  email: str
  provider_type: str = Literal["fire", "medical", "police"]
  username: Optional[str] = Field(default = None, unique = True)
  hashed_password: Optional[str] = None
  hashed_token: Optional[str] = None

class User(SQLModel, table = True):
  id: int = Field(primary_key=True)
  name: str
  email: str = Field(unique = True)
  phone: str = Field(unique = True)
  address: str
  dateOfBirth: str
  docType: str
  docID: str = Field(unique = True)
  blood: str
  hashed_password: str
  hashed_token: Optional[str] = None

engine = create_engine("postgresql://beacon:t8m%40VwBCA9g*fBTs@beacon-db.postgres.database.azure.com/beacon", echo = True)

def init_db():
  SQLModel.metadata.create_all(engine)
