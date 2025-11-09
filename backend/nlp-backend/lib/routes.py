"""
API routes for the NLP application
"""
from fastapi import APIRouter, HTTPException, Depends, Request
from lib.models import (
    ParaphraseResponse,
    SummarizationResponse,
    TextInput,
    BatchTextInput,
    TranslationInput,
    SentimentResponse,
    TranslationResponse,
    NERResponse,
    BatchSentimentResponse
)
from lib.services import ParaphraseService, SentimentService, NERService, SummarizationService, TranslationService
from lib.rate_limiter import limiter

# Create router
router = APIRouter()


def get_sentiment_service() -> SentimentService:
    """Dependency to get sentiment service"""
    from main import sentiment_service
    return sentiment_service


def get_ner_service() -> NERService:
    """Dependency to get NER service"""
    from main import ner_service
    return ner_service


def get_translation_service() -> TranslationService:
    """Dependency to get translation service"""
    from main import translation_service
    return translation_service

def get_paraphrase_service() -> ParaphraseService:
    """Dependency to get paraphrase service"""
    from main import paraphrase_service
    return paraphrase_service

def get_summarization_service() -> SummarizationService:
    """Dependency to get summarization service"""
    from main import summarization_service
    return summarization_service

# Health check endpoints
@router.get("/")
@limiter.limit("60/minute")
async def root(request: Request):
    """Basic API status endpoint"""
    return {"message": "NLP Analysis API is running!", "version": "2.0.0"}


@router.get("/health")
@limiter.limit("30/minute")
async def health_check(request: Request):
    """Detailed health check endpoint with model status"""
    from main import sentiment_model, ner_model, paraphrase_model, summarization_model
    return {
        "status": "healthy",
        "models": {
            "sentiment": sentiment_model.is_loaded() if sentiment_model else False,
            "ner": ner_model.is_loaded() if ner_model else False,
            "paraphrase": paraphrase_model.is_loaded() if paraphrase_model else False,
            "summarization": summarization_model.is_loaded() if summarization_model else False
        }
    }


# Sentiment analysis endpoints
@router.post("/analyze", response_model=SentimentResponse)
@limiter.limit("20/minute")
async def analyze_sentiment(
    request: Request,
    input_data: TextInput,
    service: SentimentService = Depends(get_sentiment_service)
):
    """
    Analyze the sentiment of the provided text
    Rate limited to 20 requests per minute per IP
    """
    try:
        return service.analyze_sentiment(input_data.text)
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Analysis failed: {str(e)}")


@router.post("/analyze-batch", response_model=BatchSentimentResponse)
@limiter.limit("10/minute")
async def analyze_batch_sentiment(
    request: Request,
    input_data: BatchTextInput,
    service: SentimentService = Depends(get_sentiment_service)
):
    """
    Analyze sentiment for multiple texts at once
    Rate limited to 10 requests per minute (more expensive operation)
    """
    try:
        results = service.analyze_batch(input_data.texts)
        return BatchSentimentResponse(results=results)
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Batch analysis failed: {str(e)}")


# NER endpoints
@router.post("/ner", response_model=NERResponse)
@limiter.limit("15/minute")
async def extract_entities(
    request: Request,
    input_data: TextInput,
    service: NERService = Depends(get_ner_service)
):
    """
    Extract named entities from the provided text
    Rate limited to 15 requests per minute (compute-intensive)
    """
    try:
        return service.extract_entities(input_data.text)
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"NER failed: {str(e)}")


# Translation endpoints
@router.post("/translate", response_model=TranslationResponse)
@limiter.limit("15/minute")
async def translate_text(
    request: Request,
    input_data: TranslationInput,
    service: TranslationService = Depends(get_translation_service)
):
    """
    Translate text from source language to target language
    Rate limited to 15 requests per minute (loads models dynamically)
    """
    try:
        translated_text = service.translate(
            input_data.text,
            input_data.source_lang,
            input_data.target_lang
        )
        return TranslationResponse(translated_text=translated_text)
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Translation failed: {str(e)}")

# Paraphrasing endpoints
@router.post("/paraphrase", response_model=ParaphraseResponse)
@limiter.limit("15/minute")
async def paraphrase_text(
    request: Request,
    input_data: TextInput,
    service: ParaphraseService = Depends(get_paraphrase_service)
):
    """
    Paraphrase the provided text
    Rate limited to 15 requests per minute
    """
    try:
        return service.paraphrase(input_data.text)
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Paraphrasing failed: {str(e)}")
    
    
# Summarization endpoints
@router.post("/summarize", response_model=SummarizationResponse)
@limiter.limit("15/minute")
async def summarize_text(
    request: Request,
    input_data: TextInput,
    service: SummarizationService = Depends(get_summarization_service)
):
    """
    Summarize the provided text
    Rate limited to 15 requests per minute
    """
    try:
        return service.summarize(input_data.text)
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Summarization failed: {str(e)}")