from fastapi import APIRouter

router = APIRouter(
    prefix="/web",
    tags=["web"]
)

@router.get("/test")
def read_test():
    return {"test_status": "Success!"}
 