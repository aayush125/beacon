from fastapi import APIRouter
from routes.user_app import websocket, auth

router = APIRouter(
  prefix="/app",
  tags=["app"]
)

router.include_router(auth.router)
router.include_router(websocket.router)
