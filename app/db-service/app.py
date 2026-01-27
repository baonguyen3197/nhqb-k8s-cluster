from fastapi import FastAPI, Request, HTTPException

app = FastAPI()

STORE_DATA = {
    1: {"id": 1, "item": "Laptop", "price": 1200},
    2: {"id": 2, "item": "Smartphone", "price": 800},
    3: {"id": 3, "item": "Tablet", "price": 400},
    4: {"id": 4, "item": "Headphones", "price": 150},
    5: {"id": 5, "item": "Smartwatch", "price": 200},
}

def role(request: Request):
    return request.headers.get("X-User-Role")

def role_check(request: Request):
    role = request.headers.get("X-User-Role")
    if role != "admin":
        raise HTTPException(status_code=403, detail="Access forbidden: Admins only.")

@app.get("/db/health")
async def health_check():
    return {"status": "DB service health ok."}

@app.get("/db")
async def get_all_items(request: Request):
    if role(request) not in ["admin", "store"]:
        raise HTTPException(status_code=403, detail="Access forbidden: Admins and Store roles only.")
    return {"items": list(STORE_DATA.values())}

@app.post("/db")
async def add_item(request: Request, item: dict):
    role_check(request)
    new_id = max(STORE_DATA.keys()) + 1
    STORE_DATA[new_id] = {"id": new_id, **item}
    return {"message": "Item added successfully.", "item": STORE_DATA[new_id]}

@app.put("/db/{item_id}")
async def update_item(request: Request, item_id: int, item: dict):
    role_check(request)
    if item_id not in STORE_DATA:
        raise HTTPException(status_code=404, detail="Item not found.")
    STORE_DATA[item_id].update(item)
    return {"message": "Item updated successfully.", "item": STORE_DATA[item_id]}

@app.delete("/db/{item_id}")
async def delete_item(request: Request, item_id: int):
    role_check(request)
    if item_id not in STORE_DATA:
        raise HTTPException(status_code=404, detail="Item not found.")
    deleted_item = STORE_DATA.pop(item_id)
    return {"message": "Item deleted successfully.", "item": deleted_item}