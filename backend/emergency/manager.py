from typing import List
from fastapi import WebSocket

from db import User, EmergencyType, EmergencyStatus, Provider, Responder
from emergency.classes import ServerEmergency

class EmergencyManager:
  def __init__(self) -> None:
    self.active_emergencies: list[ServerEmergency] = []

  async def create_emergency(
    self,
    user: User,
    user_ws: WebSocket,
    lat: float,
    lng: float,
    types: List[EmergencyType]
  ):
    # Check if user already has an existing emergency
    # If they do, cancel and remove the emergency.
    await self.cancel_emergency(user)

    new = ServerEmergency(user, user_ws, lat, lng, types)
    await new.find_providers()
    self.active_emergencies.append(new)
    await self.cleanup(new)

  def find_by_id(self, id: int):
    for e in self.active_emergencies:
      if e.get_id() == id:
        return e
    return None

  def find_by_user(self, user: User):
    for e in self.active_emergencies:
      if e.get_user_id() == user.id:
        return e
    return None

  async def provider_reject_emergency(
    self,
    emergency_id: int,
    provider_name: str,
    provider_type: EmergencyType
  ):
    """
    Rejects the emergency, informing the user about the rejection.

    Note: Rejection from a single provider does not cancel the emergency.
    """
    e = self.find_by_id(emergency_id)
    if e is not None:
      await e.handle_reject_provider(provider_name, provider_type)
      await self.cleanup(e)

  async def provider_accept_emergency(
    self,
    emergency_id: int,
    responder_id: int,
    provider_type: EmergencyType
  ):
    """
    Accepts the emergency, and informs the user about it
    """
    e = self.find_by_id(emergency_id)
    if e is not None:
      await e.assign_responder(responder_id, provider_type)
  
  async def cancel_emergency(
    self,
    user: User
  ):
    """
    Cancels the emergency, making sure to inform any connected providers
    """
    e = self.find_by_user(user)
    if e is not None:
      await self.cleanup(e, forced = True)
      

  async def responder_resolve_emergency(
    self,
    emergency_id: int,
    responder: Responder
  ):
    e = self.find_by_id(emergency_id)
    if e is not None:
      await e.handle_resolve_responder(responder)
      await self.cleanup(e)

  async def responder_reject_emergency(
    self,
    emergency_id: int,
    responder: Responder
  ):
    e = self.find_by_id(emergency_id)
    if e is not None:
      await e.handle_reject_responder(responder)
      await self.cleanup(e)

  async def update_responder_pos(
    self,
    responder_id: int,
    lat: float,
    lng: float
  ):
    for e in self.active_emergencies:
      if await e.update_responder_pos(responder_id, lat, lng):
        return
      
  async def cleanup(
    self,
    emergency: ServerEmergency,
    forced = False
  ):
    if forced or await emergency.is_complete():
      await emergency.cleanup()
      self.active_emergencies.remove(emergency)
