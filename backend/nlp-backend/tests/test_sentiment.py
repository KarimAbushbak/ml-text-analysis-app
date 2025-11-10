"""
Tests for sentiment analysis endpoints

Note: If these tests fail with 429 (Too Many Requests), it means rate limiting
is working correctly! The rate limiter from previous tests may still be active.
Run sentiment tests separately: pytest tests/test_sentiment.py
"""
import pytest


@pytest.mark.integration
def test_sentiment_analysis_positive(client, sample_texts):
    """
    Test sentiment analysis with positive text
    """
    response = client.post(
        "/analyze",
        json={"text": sample_texts["positive"]}
    )
    
    assert response.status_code == 200
    data = response.json()
    
    # Check response structure
    assert "sentiment" in data
    assert "confidence" in data
    assert "all_scores" in data
    
    # Check sentiment is positive
    assert data["sentiment"] == "Positive"
    assert data["confidence"] > 0.5  # Should be confident
    assert isinstance(data["all_scores"], list)


@pytest.mark.integration
def test_sentiment_analysis_negative(client, sample_texts):
    """
    Test sentiment analysis with negative text
    """
    response = client.post(
        "/analyze",
        json={"text": sample_texts["negative"]}
    )
    
    assert response.status_code == 200
    data = response.json()
    
    # Check sentiment is negative
    assert data["sentiment"] == "Negative"
    assert data["confidence"] > 0.5


@pytest.mark.integration
def test_sentiment_analysis_neutral(client, sample_texts):
    """
    Test sentiment analysis with neutral text
    """
    response = client.post(
        "/analyze",
        json={"text": sample_texts["neutral"]}
    )
    
    assert response.status_code == 200
    data = response.json()
    
    # Should get a result (Positive, Negative, or Neutral)
    assert data["sentiment"] in ["Positive", "Negative", "Neutral"]


@pytest.mark.integration
def test_batch_sentiment_analysis(client, sample_batch_texts):
    """
    Test batch sentiment analysis
    """
    response = client.post(
        "/analyze-batch",
        json={"texts": sample_batch_texts}
    )
    
    assert response.status_code == 200
    data = response.json()
    
    # Check response structure
    assert "results" in data
    assert len(data["results"]) == len(sample_batch_texts)
    
    # Check each result has required fields
    for result in data["results"]:
        assert "text" in result
        assert "sentiment" in result
        assert "confidence" in result
        assert result["sentiment"] in ["Positive", "Negative", "Neutral"]
        assert 0 <= result["confidence"] <= 1


@pytest.mark.integration
def test_batch_sentiment_empty_list(client):
    """
    Test batch analysis with empty list (should fail)
    """
    response = client.post(
        "/analyze-batch",
        json={"texts": []}
    )
    
    # Should return validation error
    assert response.status_code == 422  # Validation error

