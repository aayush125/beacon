from fastapi import FastAPI
from routes import web, app
from db import init_db
import cloudinary

init_db()

cloudinary.config(
  cloud_name = "dgglbr1hh",
  api_key = "681571449771746",
  api_secret = "7f7192A6OXTfqO8r14R03ZRp4ks",
  secure = True
)

api = FastAPI(root_path="/api")

api.include_router(web.router)
api.include_router(app.router)

@api.get("/")
def read_root():
  return ["Beacon API.", "Visit /docs for API Documentation."]
