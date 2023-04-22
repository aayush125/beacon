from fastapi import APIRouter
from routes.web.provider import auth

router = APIRouter(
  prefix="/provider"
)

router.include_router(auth.router)
