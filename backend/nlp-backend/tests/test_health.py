"""
Tests for health check endpoints
These verify that the API is running and models are loaded
"""
import pytest


@pytest.mark.integration
def test_root_endpoint(client):
    """
    Test the root endpoint returns correct message
    """
    response = client.get("/")
    
    assert response.status_code == 200
    data = response.json()
    assert data["message"] == "NLP Analysis API is running!"
    assert data["version"] == "2.0.0"


@pytest.mark.integration
def test_health_check_endpoint(client):
    """
    Test the health check endpoint returns model status
    """
    response = client.get("/health")
    
    assert response.status_code == 200
    data = response.json()
    
    # Check structure
    assert "status" in data
    assert "models" in data
    assert data["status"] == "healthy"
    
    # Check all models are loaded
    models = data["models"]
    assert models["sentiment"] == True
    assert models["ner"] == True
    assert models["paraphrase"] == True
    assert models["summarization"] == True

