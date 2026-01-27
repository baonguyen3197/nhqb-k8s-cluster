from fastapi import FastAPI
import requests

app = FastAPI()
STORE_URL = "http://store-service:8000/store"

@app.get("/users/health")
async def health_check():
    return {"status": "User health ok."}

@app.get("/shop")
async def shop():
    response = requests.get(
        STORE_URL,
        headers={"X-User-Role": "user"},
        timeout=5
    )
    store_items = response.json().get("store_items", [])
    return {"message": "User Service is running.", "store_items": store_items}