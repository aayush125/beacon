from fastapi import APIRouter
from routes.responder_app import auth, endpoints

router = APIRouter(
  prefix="/responder",
  tags=["responder"]
)

router.include_router(auth.router)
router.include_router(endpoints.router)
