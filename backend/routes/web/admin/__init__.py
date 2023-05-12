from fastapi import APIRouter
from routes.web.admin import applications, auth

router = APIRouter(
  prefix="/admin"
)

router.include_router(applications.router)
router.include_router(auth.router)
