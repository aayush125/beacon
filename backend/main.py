from fastapi import FastAPI
from routes import web
from db import init_db
import cloudinary

init_db()

cloudinary.config(
  cloud_name = "dgglbr1hh",
  api_key = "681571449771746",
  api_secret = "7f7192A6OXTfqO8r14R03ZRp4ks",
  secure = True
)

app = FastAPI(root_path="/api")

app.include_router(web.router)

@app.get("/")
def read_root():
  return ["Beacon API.", "Visit /docs for API Documentation."]
