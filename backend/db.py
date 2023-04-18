from typing import Literal
from sqlmodel import Field, SQLModel, create_engine

class Provider(SQLModel, table = True):
    id: int = Field(primary_key = True)
    name: str
    approved: bool
    pan_no: int
    reg_no: str
    address: str
    locationLat: float
    locationLng: float
    contact_no: str
    email: str  
    provider_type: str = Literal["fire", "medical", "police"]

engine = create_engine("postgresql://beacon:a@localhost/beacon", echo = True)

def init_db():
    SQLModel.metadata.create_all(engine)
