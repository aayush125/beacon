from fastapi import APIRouter
from routes.web.provider import auth, responder, websocket

router = APIRouter(
  prefix="/provider"
)

router.include_router(auth.router)
router.include_router(responder.router)
router.include_router(websocket.router)
