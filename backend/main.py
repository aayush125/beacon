from math import sin, cos
from time import time
from fastapi import FastAPI, WebSocket
from fastapi.responses import HTMLResponse
from asyncio import sleep

from routes import web, app

# Todo: Initialize database connection here

api = FastAPI(root_path="/api")

api.include_router(web.router)
api.include_router(app.router)

@api.get("/")
def read_root():
  return ["Beacon API.", "Visit /docs for API Documentation."]

@api.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    await websocket.accept()

    while True:
      data = await websocket.receive_json()
      print(data)
      
      # data["lat"] += sin(time()) * 0.005
      # data["lon"] += cos(time()) * 0.005

      # print("sending: ", data)
      # await websocket.send_json(data)
      # await sleep(1);
