"""
Tests for paraphrasing endpoint
"""
import pytest


@pytest.mark.integration
@pytest.mark.slow
def test_paraphrase_simple_text(client):
    """
    Test paraphrasing with simple text
    """
    text = "The weather is nice today."
    response = client.post(
        "/paraphrase",
        json={"text": text}
    )
    
    assert response.status_code == 200
    data = response.json()
    
    # Check response structure
    assert "paraphrased_text" in data
    assert len(data["paraphrased_text"]) > 0
    
    # Paraphrased text might be different (but not guaranteed)
    assert isinstance(data["paraphrased_text"], str)


@pytest.mark.integration
@pytest.mark.slow
def test_paraphrase_longer_text(client):
    """
    Test paraphrasing with longer text
    """
    text = "Machine learning is a subset of artificial intelligence that focuses on building systems that can learn from data."
    response = client.post("/paraphrase", json={"text": text})
    
    assert response.status_code == 200
    data = response.json()
    assert "paraphrased_text" in data
    assert len(data["paraphrased_text"]) > 0


@pytest.mark.integration
def test_paraphrase_empty_text(client):
    """
    Test paraphrasing with empty text (should fail)
    """
    response = client.post("/paraphrase", json={"text": ""})
    
    # Should return validation error
    assert response.status_code == 422

