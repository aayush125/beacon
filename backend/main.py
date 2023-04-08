from fastapi import FastAPI

from routes import web

# Todo: Initialize database connection here

app = FastAPI(root_path="/api")

app.include_router(web.router)

@app.get("/")
def read_root():
  return ["Beacon API.", "Visit /docs for API Documentation."]
