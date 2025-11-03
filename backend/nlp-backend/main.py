"""
Main FastAPI application with clean architecture
"""
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import uvicorn
import logging

# Import our modules
from lib.routes import router
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

# Initialize FastAPI app
app = FastAPI(
    title="NLP Analysis API",
    description="A REST API for sentiment analysis, NER, translation, paraphrasing, and summarization using Hugging Face transformers",
    version="2.0.0"
)

# Add CORS middleware to allow requests from Flutter app
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, specify your Flutter app's origin
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
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
    try:
        sentiment_model.load_model()
        ner_model.load_model()
        paraphrase_model.load_model()
        summarization_model.load_model()
        # Translation models are loaded on-demand based on language pairs
        logger.info("All models loaded successfully!")
    except Exception as e:
        logger.error(f"Error loading models: {e}")
        raise


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
