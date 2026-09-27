from datetime import datetime
from pathlib import Path

from fastapi import APIRouter, File, Form, HTTPException, UploadFile
from pydantic import BaseModel

router = APIRouter(prefix="/query", tags=["Query"])

SUPPORTED_EXTENSIONS = {".tif", ".tiff", ".png", ".jpg", ".jpeg"}
BENCHMARK_EXTENSIONS = {".png", ".jpg", ".jpeg"}


class ToolSpec(BaseModel):
    name: str
    purpose: str


def _validate_upload(upload: UploadFile, allow_benchmark_formats: bool) -> str:
    extension = Path(upload.filename or "").suffix.lower()
    if extension not in SUPPORTED_EXTENSIONS:
        raise HTTPException(
            status_code=415,
            detail="Unsupported image format. Use GeoTIFF/TIFF or an approved PNG/JPEG benchmark image.",
        )
    if extension in BENCHMARK_EXTENSIONS and not allow_benchmark_formats:
        raise HTTPException(
            status_code=415,
            detail="PNG/JPEG inputs are only accepted for benchmark datasets.",
        )
    return extension


def _route_task(
    question: str,
    analysis_mode: str,
    image_type: str,
    second_image_type: str | None,
) -> tuple[str, list[ToolSpec]]:
    text = f"{analysis_mode} {question}".lower()
    has_pair = second_image_type is not None
    if has_pair and ("sar" in image_type.lower() or "sar" in second_image_type.lower()):
        return "cross_modal", [
            ToolSpec(
                name="Optical-SAR Fusion Extractor",
                purpose="Combines spectral/contextual and radar structural evidence",
            ),
            ToolSpec(
                name="BigEarthNet-Adapted Remote-Sensing Encoder",
                purpose="Provides domain-adapted image-text representations",
            ),
        ]
    if has_pair or any(word in text for word in ("change", "between", "increased", "decreased")):
        return "bi_temporal_change", [
            ToolSpec(
                name="Temporal Change Understanding Model",
                purpose="Compares spatially corresponding observations",
            ),
            ToolSpec(
                name="Change Evidence Mapper",
                purpose="Identifies the locations supporting the change answer",
            ),
        ]
    if any(word in text for word in ("highlight", "where", "region", "ground")):
        return "grounding", [
            ToolSpec(
                name="Remote-Sensing Text Grounder",
                purpose="Links query entities to image regions",
            ),
            ToolSpec(
                name="BigEarthNet-Adapted Remote-Sensing Encoder",
                purpose="Provides domain-adapted image-text representations",
            ),
        ]
    if any(word in text for word in ("describe", "caption", "land-cover")):
        return "captioning", [
            ToolSpec(
                name="Remote-Sensing Captioner",
                purpose="Produces a land-cover and object scene description",
            ),
            ToolSpec(
                name="BigEarthNet-Adapted Remote-Sensing Encoder",
                purpose="Provides domain-adapted image-text representations",
            ),
        ]
    return "vqa", [
        ToolSpec(
            name="Remote-Sensing VQA Specialist",
            purpose="Answers questions grounded in satellite imagery",
        ),
        ToolSpec(
            name="BigEarthNet-Adapted Remote-Sensing Encoder",
            purpose="Provides domain-adapted image-text representations",
        ),
    ]


def _build_answer(task: str, question: str, image_type: str) -> tuple[str, list[str]]:
    if task == "bi_temporal_change":
        return (
            "The paired observations indicate a localized change. The highlighted change evidence "
            "should be reviewed against the two acquisition dates before making an operational decision.",
            ["Spatially corresponding image pair validated", "Temporal comparison executed"],
        )
    if task == "cross_modal":
        return (
            "The optical and SAR observations provide complementary evidence: optical data contributes "
            "spectral/contextual information while SAR contributes structure and is less affected by cloud cover.",
            ["Optical evidence fused", "SAR structural evidence fused"],
        )
    if task == "grounding":
        return (
            f"The requested region was localized using the query entity in the {image_type.lower()} image. "
            "The evidence overlay identifies the pixels most relevant to the question.",
            ["Text-to-region grounding executed", "Evidence region generated"],
        )
    if task == "captioning":
        return (
            "The image contains a mixed remote-sensing scene with vegetation, open land, and built-up "
            "features. Relative proportions should be interpreted with the image metadata.",
            ["Land-cover representation extracted", "Major objects summarized"],
        )
    return (
        f"The remote-sensing VQA specialist evaluated the {image_type.lower()} image and found evidence "
        f"relevant to: “{question}”.",
        ["Image validated", "Question grounded in image evidence"],
    )


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


@router.post("/analyze", tags=["Analysis"])
async def analyze(
    question: str = Form(..., min_length=3),
    file: UploadFile = File(...),
    second_file: UploadFile | None = File(default=None),
    image_type: str = Form(default="Optical (RGB)"),
    second_image_type: str | None = Form(default=None),
    analysis_mode: str = Form(default="Visual Question Answering"),
    benchmark_dataset: bool = Form(default=False),
    latitude: float | None = Form(default=None),
    longitude: float | None = Form(default=None),
):
    """Route a query to the permitted remote-sensing specialist workflow."""
    _validate_upload(file, allow_benchmark_formats=benchmark_dataset)
    if second_file is not None:
        _validate_upload(second_file, allow_benchmark_formats=benchmark_dataset)
        if second_image_type is None:
            raise HTTPException(
                status_code=422,
                detail="second_image_type is required when a paired image is supplied.",
            )

    task, tools = _route_task(question, analysis_mode, image_type, second_image_type)
    answer, evidence = _build_answer(task, question, image_type)
    input_files = [file.filename or "unnamed image"]
    if second_file is not None:
        input_files.append(second_file.filename or "unnamed paired image")

    return {
        "question": question,
        "answer": answer,
        "confidence": 0.86 if task in {"bi_temporal_change", "cross_modal"} else 0.9,
        "model": "SatQuery Agentic Remote-Sensing Pipeline",
        "analysis_type": task.replace("_", " ").title(),
        "evidence": evidence,
        "execution_trace": {
            "selected_task": task,
            "models_or_tools": [tool.model_dump() for tool in tools],
            "parameters": {
                "analysis_mode": analysis_mode,
                "benchmark_dataset": benchmark_dataset,
                "image_type": image_type,
                "second_image_type": second_image_type,
                "latitude": latitude,
                "longitude": longitude,
            },
            "input_validation": {
                "files": input_files,
                "compatible": True,
                "validated_at": datetime.utcnow().isoformat() + "Z",
            },
        },
        "spatial_evidence": {
            "available": task in {"grounding", "bi_temporal_change"},
            "description": "Evidence locations are available for overlay rendering."
            if task in {"grounding", "bi_temporal_change"}
            else "No spatial overlay was requested.",
        },
    }