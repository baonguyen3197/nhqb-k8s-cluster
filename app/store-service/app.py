import time
from fastapi import FastAPI
import requests

app = FastAPI()
DB_SERVICE_URL = "http://db-service:8000/db"

@app.get("/store/health")
async def health_check():
    return {"status": "Store health ok."}

@app.get("/store")
async def get_store():
    response = requests.get(
        DB_SERVICE_URL,
        headers={"X-User-Role": "store"},
        timeout=5
    )
    items = response.json().get("items", [])
    return {"store_items": items}
