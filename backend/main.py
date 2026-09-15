from fastapi import FastAPI
from api.upload import router as upload_router
from api.query import router as query_router

app = FastAPI(
    title="SatQuery AI API",
    description="Backend API for SatQuery AI",
    version="1.0.0"
)

app.include_router(upload_router)
app.include_router(query_router)


@app.get("/")
def root():
    return {
        "message": "SatQuery AI Backend is running"
    }


@app.get("/health")
def health():
    return {
        "status": "healthy"
    }