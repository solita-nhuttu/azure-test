from fastapi import FastAPI

app = FastAPI()

@app.get("/ping")
async def ping():
    return {"message": "pong"}

# Optional: Root endpoint for testing
@app.get("/")
async def read_root():
    return {"message": "Hello World"}
