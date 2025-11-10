"""
Unit tests for Pydantic models
Tests data validation logic
"""
import pytest
from pydantic import ValidationError
from lib.models import (
    TextInput,
    BatchTextInput,
    TranslationInput,
    SentimentResponse,
    Entity,
    NERResponse
)


@pytest.mark.unit
def test_text_input_valid():
    """
    Test TextInput with valid data
    """
    text_input = TextInput(text="This is a valid text")
    assert text_input.text == "This is a valid text"


@pytest.mark.unit
def test_text_input_strips_whitespace():
    """
    Test that TextInput strips leading/trailing whitespace
    """
    text_input = TextInput(text="  text with spaces  ")
    assert text_input.text == "text with spaces"


@pytest.mark.unit
def test_text_input_empty_fails():
    """
    Test that empty text raises validation error
    """
    with pytest.raises(ValidationError):
        TextInput(text="")


@pytest.mark.unit
def test_text_input_whitespace_only_fails():
    """
    Test that whitespace-only text raises validation error
    """
    with pytest.raises(ValidationError):
        TextInput(text="   ")


@pytest.mark.unit
def test_text_input_too_long_fails():
    """
    Test that text over 5000 characters fails validation
    """
    with pytest.raises(ValidationError):
        TextInput(text="a" * 6000)


@pytest.mark.unit
def test_batch_text_input_valid():
    """
    Test BatchTextInput with valid data
    """
    batch = BatchTextInput(texts=["text1", "text2", "text3"])
    assert len(batch.texts) == 3


@pytest.mark.unit
def test_batch_text_input_empty_list_fails():
    """
    Test that empty list fails validation
    """
    with pytest.raises(ValidationError):
        BatchTextInput(texts=[])


@pytest.mark.unit
def test_batch_text_input_too_many_fails():
    """
    Test that over 100 items fails validation
    """
    with pytest.raises(ValidationError):
        BatchTextInput(texts=["text"] * 101)


@pytest.mark.unit
def test_translation_input_valid():
    """
    Test TranslationInput with valid data
    """
    translation = TranslationInput(
        text="Hello",
        source_lang="en",
        target_lang="es"
    )
    assert translation.text == "Hello"
    assert translation.source_lang == "en"
    assert translation.target_lang == "es"


@pytest.mark.unit
def test_translation_input_defaults():
    """
    Test TranslationInput uses default language codes
    """
    translation = TranslationInput(text="Hello")
    assert translation.source_lang == "en"
    assert translation.target_lang == "ar"


@pytest.mark.unit
def test_translation_input_invalid_lang_code():
    """
    Test that invalid language codes fail validation
    """
    with pytest.raises(ValidationError):
        TranslationInput(
            text="Hello",
            source_lang="toolongcode",  # Too long
            target_lang="es"
        )


@pytest.mark.unit
def test_sentiment_response_valid():
    """
    Test SentimentResponse creation
    """
    response = SentimentResponse(
        sentiment="Positive",
        confidence=0.95,
        all_scores=[{"label": "positive", "score": 0.95}]
    )
    assert response.sentiment == "Positive"
    assert response.confidence == 0.95


@pytest.mark.unit
def test_entity_valid():
    """
    Test Entity model creation
    """
    entity = Entity(
        text="Apple Inc.",
        label="ORG",
        score=0.99
    )
    assert entity.text == "Apple Inc."
    assert entity.label == "ORG"
    assert entity.score == 0.99


@pytest.mark.unit
def test_ner_response_valid():
    """
    Test NERResponse creation
    """
    entities = [
        Entity(text="Apple Inc.", label="ORG", score=0.99),
        Entity(text="California", label="LOC", score=0.98)
    ]
    response = NERResponse(
        entities=entities,
        text="Apple Inc. is in California"
    )
    assert len(response.entities) == 2
    assert response.text == "Apple Inc. is in California"

