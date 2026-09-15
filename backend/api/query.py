from fastapi import APIRouter
from pydantic import BaseModel

router = APIRouter(prefix="/query", tags=["Query"])


class QueryRequest(BaseModel):
    question: str
    image_id: str | None = None


@router.post("/")
async def process_query(request: QueryRequest):
    return {
        "question": request.question,
        "answer": "This is a temporary response. AI model will be connected later.",
        "status": "success"
    }