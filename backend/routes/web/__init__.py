from fastapi import APIRouter
from routes.web import provider, admin

router = APIRouter(
  prefix="/web",
  tags=["web"]
)

router.include_router(provider.router)
router.include_router(admin.router)
