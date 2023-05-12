from datetime import datetime
from typing import List, Optional
from sqlmodel import Column, Field, SQLModel, DateTime, Relationship, create_engine, or_
from sqlalchemy.sql import func
from enum import Enum

class EmergencyType(str, Enum):
  FIRE = "fire"
  MEDICAL = "medical"
  POLICE = "police"

class EmergencyStatus(str, Enum):
  WAITING = "waiting_for_provider"
  SENT = "responder_sent"
  RESOLVED = "resolved"
  REJECTED = "rejected"


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
  provider_type: EmergencyType
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
  emergencies: List["Emergency"] = Relationship(back_populates="user")


class ResponderEmergencyLink(SQLModel, table = True):
  emergency_id: int = Field(
    foreign_key="emergency.id", primary_key=True
  )
  responder_id: int = Field(
    foreign_key="responder.id", primary_key=True
  )
  responder_type: EmergencyType

  emergency: "Emergency" = Relationship(back_populates="responder_links")
  responder: "Responder" = Relationship(back_populates="emergency_links")


class Responder(SQLModel, table = True):
  id: int = Field(primary_key=True)
  name: str
  phone: str = Field(unique = True)
  hashed_password: str
  hashed_token: Optional[str] = None
  
  last_active_timestamp: int = 0
  last_lat: float = 0
  last_lng: float = 0

  provider_id: int = Field(foreign_key="provider.id")
  provider: Provider = Relationship(back_populates="responders")
  
  emergency_links: List[ResponderEmergencyLink] = Relationship(back_populates="responder")


class Emergency(SQLModel, table = True):
  id: int = Field(primary_key=True)
  status: EmergencyStatus
  locationLat: float
  locationLng: float
  time: datetime = Field(sa_column=Column(DateTime(timezone=True), server_default=func.now()))

  user_id: int = Field(foreign_key="user.id")
  user: User = Relationship(back_populates="emergencies")
  
  responder_links: List[ResponderEmergencyLink] = Relationship(back_populates="emergency")


engine = create_engine("postgresql://beacon:t8m%40VwBCA9g*fBTs@beacon-db.postgres.database.azure.com/beacon", echo = True)

def init_db():
  SQLModel.metadata.create_all(engine)

  # Perform emergencies cleanup
  from sqlmodel import select, Session

  session = Session(engine)
  statement = select(Emergency).where(or_(Emergency.status == EmergencyStatus.SENT, Emergency.status == EmergencyStatus.WAITING))
  results = session.exec(statement)

  for e in results:
    e.status = EmergencyStatus.REJECTED
    session.add(e)
  
  session.commit()
  session.close()