"""
Business logic services for NLP operations
"""
import logging
from typing import List, Dict, Any
from lib.providers.model_providers import (
    SentimentModelProvider,
    NERModelProvider,
    SummarizationModelProvider,
    TranslationModelProvider,
    ParaphraseModelProvider,
)
from lib.models import Entity, NERResponse, SentimentResponse, BatchSentimentResult, ParaphraseResponse, SummarizationResponse

logger = logging.getLogger(__name__)


class SentimentService:
    """Service for sentiment analysis operations"""
    
    def __init__(self, model_provider: SentimentModelProvider):
        self.model_provider = model_provider
    
    def analyze_sentiment(self, text: str) -> SentimentResponse:
        """
        Analyze sentiment of a single text
        
        Args:
            text: The text to analyze
            
        Returns:
            SentimentResponse with sentiment, confidence, and scores
        """
        results = self.model_provider.predict(text)
        
        # Extract the highest scoring sentiment
        if isinstance(results, list) and len(results) > 0:
            if isinstance(results[0], list):
                best_result = max(results[0], key=lambda x: x['score'])
                all_scores = results[0]
            else:
                best_result = results[0]
                all_scores = results
        else:
            best_result = results
            all_scores = None
        
        # Map sentiment labels to more user-friendly format
        sentiment_label = best_result['label'].lower()
        if 'positive' in sentiment_label:
            sentiment = "Positive"
        elif 'negative' in sentiment_label:
            sentiment = "Negative"
        else:
            sentiment = "Neutral"
        
        return SentimentResponse(
            sentiment=sentiment,
            confidence=round(best_result['score'], 3),
            all_scores=all_scores
        )
    
    def analyze_batch(self, texts: List[str]) -> List[BatchSentimentResult]:
        """
        Analyze sentiment for multiple texts
        
        Args:
            texts: List of texts to analyze
            
        Returns:
            List of BatchSentimentResult objects
        """
        results = []
        for text in texts:
            if text.strip():
                analysis_result = self.analyze_sentiment(text)
                results.append(BatchSentimentResult(
                    text=text,
                    sentiment=analysis_result.sentiment,
                    confidence=analysis_result.confidence
                ))
        return results


class NERService:
    """Service for Named Entity Recognition operations"""
    
    def __init__(self, model_provider: NERModelProvider):
        self.model_provider = model_provider
    
    def extract_entities(self, text: str) -> NERResponse:
        """
        Extract named entities from text
        
        Args:
            text: The text to process
            
        Returns:
            NERResponse with extracted entities
        """
        entities_result = self.model_provider.predict(text)
        
        # Convert to Entity objects
        entities = []
        for ent in entities_result:
            # Handle both aggregation strategies
            entity_text = ent.get('word') or ent.get('entity')
            entity_label = ent.get('entity_group') or ent.get('entity')
            
            entities.append(Entity(
                text=entity_text,
                label=entity_label,
                score=round(ent['score'], 3)
            ))
        
        return NERResponse(
            entities=entities,
            text=text
        )


class TranslationService:
    """Service for translation operations"""
    
    def __init__(self, model_provider: TranslationModelProvider):
        self.model_provider = model_provider
    
    def translate(
        self, 
        text: str, 
        source_lang: str = "en", 
        target_lang: str = "ar"
    ) -> str:
        """
        Translate text from source language to target language
        
        Args:
            text: The text to translate
            source_lang: Source language code
            target_lang: Target language code
            
        Returns:
            Translated text
        """
        translation_result = self.model_provider.predict(text, source_lang, target_lang)
        return translation_result[0]['translation_text']

class ParaphraseService:
    """Service for paraphrasing operations"""
    
    def __init__(self, model_provider: ParaphraseModelProvider):
        self.model_provider = model_provider
    
    def paraphrase(self, text: str) -> ParaphraseResponse:
        """
        Paraphrase the given text
        
        Args:
            text: The text to paraphrase

        Returns:
            ParaphraseResponse object containing the paraphrased text
        """
        paraphrase_result = self.model_provider.predict(text)
        return ParaphraseResponse(paraphrased_text=paraphrase_result[0]['generated_text'])

class SummarizationService:
    """Service for text summarization operations"""

    def __init__(self, model_provider: SummarizationModelProvider):
        self.model_provider = model_provider
    
    def summarize(self, text: str) -> SummarizationResponse:
        """
        Summarize the given text
        
        Args:
            text: The text to summarize

        Returns:
            SummarizationResponse with summarized text
        """
        summary_result = self.model_provider.predict(text)
        # Hugging Face summarization pipeline returns 'summary_text' key
        return SummarizationResponse(summary_text=summary_result[0]['summary_text'])

        