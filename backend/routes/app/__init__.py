from fastapi import APIRouter
from routes.app import auth

router = APIRouter(
  prefix="/app",
  tags=["app"]
)

router.include_router(auth.router)
