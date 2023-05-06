from db import Responder
from emergency import ServerEmergency

class EmergencyManager:
  def __init__(self):
    self.active_emergencies: list[ServerEmergency] = []

  async def add_emergency(self, emergency: ServerEmergency):
    res = await emergency.async_init()
    if (res):
      self.active_emergencies.append(emergency)
    return res
  
  async def remove_emergency(self, emergency: ServerEmergency):
    await emergency.reject()
    try:
      self.active_emergencies.remove(emergency)
    except ValueError:
      pass

  async def resolve_emergency(self, emergency: ServerEmergency):
    await emergency.resolve()
    try:
      self.active_emergencies.remove(emergency)
    except ValueError:
      pass

  def get_emergency(self, id: int):
    for e in self.active_emergencies:
      if e.id_equals(id):
        return e
    return None
  
  def get_emergency_from_responder(self, responder: Responder):
    found = None
    for e in self.active_emergencies:
      if e.has_responder(responder):
        found = e
        break
    return found

  async def reject_emergency(self, id: int):
    e = self.get_emergency(id)
    if e is None: 
      return
    
    await e.reject()
    self.active_emergencies.remove(e)

  async def accept_emergency(self, id: int, responder_id: int):
    e = self.get_emergency(id)
    if e is None: 
      return
    
    await e.accept(responder_id)

