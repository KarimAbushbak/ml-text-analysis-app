"""
Pydantic models for request and response validation
"""
from pydantic import BaseModel, Field
from typing import Optional, List


class TextInput(BaseModel):
    """Input model for text-based operations"""
    text: str = Field(..., min_length=1, description="The text to process")


class BatchTextInput(BaseModel):
    """Input model for batch text processing"""
    texts: List[str] = Field(..., min_items=1, description="List of texts to process")


class TranslationInput(BaseModel):
    """Input model for translation"""
    text: str = Field(..., min_length=1, description="The text to translate")
    source_lang: str = Field(default="en", description="Source language code")
    target_lang: str = Field(default="ar", description="Target language code")


class SentimentResponse(BaseModel):
    """Response model for sentiment analysis"""
    sentiment: str = Field(..., description="The detected sentiment (Positive/Negative/Neutral)")
    confidence: float = Field(..., ge=0.0, le=1.0, description="Confidence score")
    all_scores: Optional[List[dict]] = Field(default=None, description="All sentiment scores")


class TranslationResponse(BaseModel):
    """Response model for translation"""
    translated_text: str = Field(..., description="The translated text")


class Entity(BaseModel):
    """Model for a named entity"""
    text: str = Field(..., description="The entity text")
    label: str = Field(..., description="The entity label/type")
    score: float = Field(..., ge=0.0, le=1.0, description="Confidence score")


class NERResponse(BaseModel):
    """Response model for Named Entity Recognition"""
    entities: List[Entity] = Field(..., description="List of detected entities")
    text: str = Field(..., description="The original text")


class BatchSentimentResult(BaseModel):
    """Result for a single text in batch analysis"""
    text: str = Field(..., description="The analyzed text")
    sentiment: str = Field(..., description="The detected sentiment")
    confidence: float = Field(..., ge=0.0, le=1.0, description="Confidence score")


class BatchSentimentResponse(BaseModel):
    """Response model for batch sentiment analysis"""
    results: List[BatchSentimentResult] = Field(..., description="Results for each text")

class ParaphraseResponse(BaseModel):
    """Response model for paraphrasing"""
    paraphrased_text: str = Field(..., description="The paraphrased text")

class SummarizationResponse(BaseModel):
    """Response model for text summarization"""
    summary_text: str = Field(..., description="The summarized text")