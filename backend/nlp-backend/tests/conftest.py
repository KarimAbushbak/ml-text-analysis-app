"""
Pytest fixtures and configuration for tests
Fixtures are reusable test components
"""
import pytest
from fastapi.testclient import TestClient
import sys
import os

# Add parent directory to path so we can import our modules
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from main import app


@pytest.fixture(scope="function")
def client():
    """
    Create a test client for making API requests
    This is like a fake browser that can test your API
    
    Note: Using scope="function" means each test gets a fresh client
    This helps prevent rate limit issues between tests
    """
    with TestClient(app, raise_server_exceptions=False) as test_client:
        yield test_client


@pytest.fixture
def sample_texts():
    """
    Sample texts for testing
    Provides commonly used test data
    """
    return {
        "positive": "I love this product! It's absolutely amazing and wonderful!",
        "negative": "This is terrible. I hate it. Worst experience ever.",
        "neutral": "The product is okay. It works as expected.",
        "short": "Good",
        "empty": "",
        "long": "a" * 6000,  # Over the 5000 character limit
        "valid_length": "This is a test message for analysis." * 10,  # ~370 chars
        "near_limit": "a" * 4500,  # Near limit but safe for processing
    }


@pytest.fixture
def sample_entities_text():
    """
    Text with entities for NER testing
    """
    return "Apple Inc. is located in Cupertino, California. Tim Cook is the CEO."


@pytest.fixture
def sample_translation():
    """
    Sample translation data
    """
    return {
        "text": "Hello, how are you?",
        "source_lang": "en",
        "target_lang": "es"
    }


@pytest.fixture
def sample_batch_texts():
    """
    Sample batch of texts for batch testing
    """
    return [
        "I love this!",
        "This is terrible.",
        "It's okay.",
        "Great product!",
        "Not bad."
    ]
