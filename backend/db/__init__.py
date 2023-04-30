from datetime import datetime
from typing import List, Literal, Optional
from sqlmodel import Column, Field, SQLModel, DateTime, Relationship, create_engine
from sqlalchemy.sql import func


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
  responders: List["Responder"] = Relationship(back_populates="provider")


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


class UserEmergencyLink(SQLModel, table = True):
  emergency_id: int = Field(
    foreign_key="emergency.id", primary_key=True
  )
  responder_id: int = Field(
    foreign_key="responder.id", primary_key=True
  )
  responder_type: str = Literal["fire", "medical", "police"]


class Responder(SQLModel, table = True):
  id: int = Field(primary_key=True)
  name: str
  phone: str = Field(unique = True)
  hashed_password: str
  hashed_token: Optional[str] = None
  
  provider_id: int = Field(foreign_key="provider.id")
  provider: Provider = Relationship(back_populates="responders")
  
  emergencies: List["Emergency"] = Relationship(back_populates="responders", link_model=UserEmergencyLink)


class Emergency(SQLModel, table = True):
  id: int = Field(primary_key=True)
  status: str = Literal["waiting_for_provider", "responder_sent", "resolved", "rejected"]
  locationLat: float
  locationLng: float
  time: datetime = Field(sa_column=Column(DateTime(timezone=True), server_default=func.now()))
  
  responders: List[Responder] = Relationship(back_populates="emergencies", link_model=UserEmergencyLink)


engine = create_engine("postgresql://beacon:t8m%40VwBCA9g*fBTs@beacon-db.postgres.database.azure.com/beacon", echo = True)

def init_db():
  SQLModel.metadata.create_all(engine)
