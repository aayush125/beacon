from fastapi import APIRouter, Depends
from sqlmodel import Session, select

from db import engine, Provider
from utils.types import FormStr
from utils.crypt import pw_context
from routes.web.admin.depends import check_admin

router = APIRouter(
  prefix="/applications",
  dependencies=[Depends(check_admin)]
)

@router.post("/accept/{provider_id}")
def accept_provider(provider_id: int, username: FormStr, password: FormStr):
  session = Session(engine)
  statement = select(Provider).where(Provider.id == provider_id)
  provider = session.exec(statement).one()

  provider.approved = True
  provider.username = username
  provider.hashed_password = pw_context.hash(password)

  session.add(provider)
  session.commit()


@router.post("/reject/{provider_id}")
def reject_provider(provider_id: int):
  session = Session(engine)
  statement = select(Provider).where(Provider.id == provider_id)
  provider = session.exec(statement).one()

  session.delete(provider)
  session.commit()


@router.get("")
def get_applications():
  session = Session(engine)
  statement = select(Provider).where(Provider.approved == False)
  return session.exec(statement).all()
