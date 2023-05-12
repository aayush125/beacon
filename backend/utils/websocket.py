from fastapi.websockets import WebSocket, WebSocketState

def is_connected(ws: WebSocket):
  return ws.application_state == WebSocketState.CONNECTED and ws.client_state == WebSocketState.CONNECTED
