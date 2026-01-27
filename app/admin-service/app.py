from fastapi import FastAPI
import requests

app = FastAPI()
DB_SERVICE_URL = "http://db-service:8000/db"

@app.get("/admin/health")
async def health_check():
    return {"status": "Admin health ok."}

@app.get("/items")
async def list_items():
    response = requests.get(
        DB_SERVICE_URL,
        headers={"X-User-Role": "admin"},
    )
    items = response.json().get("items", [])
    return {"items": items}

@app.post("/items")
async def create_item(item: dict):
    response = requests.post(
        DB_SERVICE_URL,
        json=item,
        headers={"X-User-Role": "admin"},
    )
    return response.json()

@app.put("/items/{item_id}")
async def modify_item(item_id: int, item: dict):
    response = requests.put(
        f"{DB_SERVICE_URL}/{item_id}",
        json=item,
        headers={"X-User-Role": "admin"},
    )
    return response.json()

@app.delete("/items/{item_id}")
async def remove_item(item_id: int):
    response = requests.delete(
        f"{DB_SERVICE_URL}/{item_id}",
        headers={"X-User-Role": "admin"},
    )
    return response.json()