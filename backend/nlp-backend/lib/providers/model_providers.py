"""
Model providers for loading and managing ML models
"""
import logging
from typing import Optional
from transformers import pipeline

logger = logging.getLogger(__name__)


class ModelProvider:
    """Base class for model providers"""
    
    def __init__(self):
        self.pipeline: Optional[pipeline] = None
        self.model_name: Optional[str] = None
    
    def load_model(self):
        """Load the model - to be implemented by subclasses"""
        raise NotImplementedError
    
    def is_loaded(self) -> bool:
        """Check if the model is loaded"""
        return self.pipeline is not None
    
    def predict(self, text: str):
        """Make a prediction - to be implemented by subclasses"""
        raise NotImplementedError


class SentimentModelProvider(ModelProvider):
    """Provider for sentiment analysis models"""
    
    def __init__(self, model_name: str = "cardiffnlp/twitter-roberta-base-sentiment-latest"):
        super().__init__()
        self.model_name = model_name
    
    def load_model(self):
        """Load the sentiment analysis model"""
        try:
            logger.info(f"Loading sentiment analysis model: {self.model_name}")
            self.pipeline = pipeline(
                "sentiment-analysis",
                model=self.model_name,
                return_all_scores=True
            )
            logger.info("Sentiment model loaded successfully!")
        except Exception as e:
            logger.error(f"Error loading sentiment model: {e}")
            # Fallback to a simpler model
            logger.info("Falling back to default sentiment model")
            self.pipeline = pipeline("sentiment-analysis")
    
    def predict(self, text: str):
        """Perform sentiment analysis on text"""
        if not self.pipeline:
            raise ValueError("Model not loaded")
        return self.pipeline(text)


class NERModelProvider(ModelProvider):
    """Provider for Named Entity Recognition models"""
    
    def __init__(self, model_name: str = "dslim/bert-base-NER"):
        super().__init__()
        self.model_name = model_name
    
    def load_model(self):
        """Load the NER model"""
        try:
            logger.info(f"Loading NER model: {self.model_name}")
            self.pipeline = pipeline(
                "ner",
                model=self.model_name,
                aggregation_strategy="simple"
            )
            logger.info("NER model loaded successfully!")
        except Exception as e:
            logger.error(f"Error loading NER model: {e}")
            raise
    
    def predict(self, text: str):
        """Perform NER on text"""
        if not self.pipeline:
            raise ValueError("Model not loaded")
        return self.pipeline(text)


class TranslationModelProvider(ModelProvider):
    """Provider for translation models"""
    
    def __init__(self):
        super().__init__()
        self.loaded_models: dict = {}
    
    def load_model(self, source_lang: str, target_lang: str):
        """Load a translation model for specific language pair"""
        model_key = f"{source_lang}-{target_lang}"
        
        if model_key in self.loaded_models:
            self.pipeline = self.loaded_models[model_key]
            return
        
        model_name = f"Helsinki-NLP/opus-mt-{source_lang}-{target_lang}"
        
        try:
            logger.info(f"Loading translation model: {model_name}")
            pipeline_obj = pipeline("translation", model=model_name)
            self.loaded_models[model_key] = pipeline_obj
            self.pipeline = pipeline_obj
            logger.info(f"Translation model {model_name} loaded successfully!")
        except Exception as e:
            logger.error(f"Error loading translation model {model_name}: {e}")
            raise ValueError(f"Translation model not available: {str(e)}")
    
    def predict(self, text: str, source_lang: str, target_lang: str):
        """Perform translation on text"""
        self.load_model(source_lang, target_lang)
        return self.pipeline(text)

class ParaphraseModelProvider(ModelProvider):
    def __init__(self, model_name: str = "tuner007/pegasus_paraphrase"):
        super().__init__()
        self.model_name = model_name
    
    def load_model(self):
        """Load the paraphrasing model"""
        try:
            logger.info(f"Loading paraphrasing model: {self.model_name}")
            self.pipeline = pipeline(
                "text2text-generation",
                model=self.model_name,
                max_length=60,
                num_beams=5,
                num_return_sequences=3
            )
            logger.info("Paraphrasing model loaded successfully!")
        except Exception as e:
            logger.error(f"Error loading paraphrasing model: {e}")
            raise
    def predict(self, text: str):
        """Perform paraphrasing on text"""
        if not self.pipeline:
            # Load on-demand if not loaded at startup
            self.load_model()
        return self.pipeline(text)

class SummarizationModelProvider(ModelProvider):
    def __init__(self, model_name: str = "facebook/bart-large-cnn"):
        super().__init__()
        self.model_name = model_name
    
    def load_model(self):
        """Load the summarization model"""
        try:
            logger.info(f"Loading summarization model: {self.model_name}")
            self.pipeline = pipeline(
                "summarization",
                model=self.model_name,
                max_length=150,
                min_length=30,
                do_sample=False
            )
            logger.info("Summarization model loaded successfully!")
        except Exception as e:
            logger.error(f"Error loading summarization model: {e}")
            raise
    
    def predict(self, text: str):
        """Perform summarization on text"""
        if not self.pipeline:
            # Load on-demand if not loaded at startup
            self.load_model()
        return self.pipeline(text)