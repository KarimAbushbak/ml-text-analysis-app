"""
Main FastAPI application with clean architecture
"""
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import uvicorn
import logging
import os
from dotenv import load_dotenv
from slowapi import _rate_limit_exceeded_handler
from slowapi.errors import RateLimitExceeded

# Load environment variables from .env file
load_dotenv()

# Import our modules
from lib.routes import router
from lib.rate_limiter import limiter, rate_limit_handler
from lib.providers.model_providers import (
    SentimentModelProvider,
    NERModelProvider,
    TranslationModelProvider,
    ParaphraseModelProvider,
    SummarizationModelProvider
)
from lib.services import ParaphraseService, SentimentService, NERService, TranslationService, SummarizationService

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Get configuration from environment variables
ALLOWED_ORIGINS = os.getenv("ALLOWED_ORIGINS", "http://localhost:8000").split(",")
ENVIRONMENT = os.getenv("ENVIRONMENT", "development")

logger.info(f"Starting application in {ENVIRONMENT} mode")
logger.info(f"Allowed CORS origins: {ALLOWED_ORIGINS}")

# Initialize FastAPI app
app = FastAPI(
    title="NLP Analysis API",
    description="A REST API for sentiment analysis, NER, translation, paraphrasing, and summarization using Hugging Face transformers",
    version="2.0.0"
)

# Add rate limiter to app state
app.state.limiter = limiter

# Add custom rate limit exception handler
app.add_exception_handler(RateLimitExceeded, rate_limit_handler)

# Add CORS middleware to allow requests from Flutter app
# SECURITY: Only allow requests from specified origins
app.add_middleware(
    CORSMiddleware,
    allow_origins=ALLOWED_ORIGINS,  # Controlled by environment variable
    allow_credentials=True,
    allow_methods=["GET", "POST"],  # Only allow needed HTTP methods
    allow_headers=["Content-Type", "Authorization", "X-API-Key"],  # Only allow needed headers
)

# Initialize model providers
sentiment_model = SentimentModelProvider()
ner_model = NERModelProvider()
translation_model = TranslationModelProvider()
paraphrase_model = ParaphraseModelProvider()
summarization_model = SummarizationModelProvider()

# Initialize services
sentiment_service = SentimentService(sentiment_model)
ner_service = NERService(ner_model)
translation_service = TranslationService(translation_model)
paraphrase_service = ParaphraseService(paraphrase_model)
summarization_service = SummarizationService(summarization_model)


def load_models():
    """Load all models on startup"""
    logger.info("Loading models...")
    
    # Load essential models (sentiment and NER)
    try:
        sentiment_model.load_model()
        logger.info("✓ Sentiment model loaded")
    except Exception as e:
        logger.error(f"✗ Error loading sentiment model: {e}")
        raise
    
    try:
        ner_model.load_model()
        logger.info("✓ NER model loaded")
    except Exception as e:
        logger.error(f"✗ Error loading NER model: {e}")
        raise
    
    # Load optional models (don't fail startup if these fail)
    try:
        paraphrase_model.load_model()
        logger.info("✓ Paraphrase model loaded")
    except Exception as e:
        logger.warning(f"⚠ Paraphrase model failed to load (will load on-demand): {e}")
    
    try:
        summarization_model.load_model()
        logger.info("✓ Summarization model loaded")
    except Exception as e:
        logger.warning(f"⚠ Summarization model failed to load (will load on-demand): {e}")
    
    # Translation models are loaded on-demand based on language pairs
    logger.info("Core models loaded successfully!")


# Load models on startup
@app.on_event("startup")
async def startup_event():
    load_models()


# Include router
app.include_router(router)


if __name__ == "__main__":
    uvicorn.run(
        "main:app",
        host="0.0.0.0",
        port=8000,
        reload=True,
        log_level="info"
    )
