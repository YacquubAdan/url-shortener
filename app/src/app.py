from fastapi import FastAPI, HTTPException, Request
from fastapi.responses import RedirectResponse
import os, hashlib, time
from .ddb import put_mapping, get_mapping

app = FastAPI()


@app.get("/")
def home_page():
    return {"home": "hello v2"}

@app.get("/healthz")
def health_check():
    return {"status": "ok", "ts": int(time.time())}

@app.post("/shorten")
async def shorten_url(request: Request):
    data = await request.json()
    url = data.get("url")
    if not url:
        raise HTTPException(status_code=400, detail="URL is required")

    short_id = hashlib.sha256(url.encode()).hexdigest()[:8]
    put_mapping(short_id, url)
    return {"short": short_id, "url": url}

@app.get("/{short_id}")
def resolve(short_id: str):
    item = get_mapping(short_id)
    if not item:
        raise HTTPException(status_code=404, detail="Short ID not found")
    
    return RedirectResponse(url=item['url'])