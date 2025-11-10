"""
Tests for translation endpoint
"""
import pytest


@pytest.mark.integration
@pytest.mark.slow
def test_translation_en_to_es(client):
    """
    Test translation from English to Spanish
    Note: Translation tests are marked as 'slow' because they load models
    """
    response = client.post(
        "/translate",
        json={
            "text": "Hello, how are you?",
            "source_lang": "en",
            "target_lang": "es"
        }
    )
    
    assert response.status_code == 200
    data = response.json()
    
    # Check response structure
    assert "translated_text" in data
    assert len(data["translated_text"]) > 0
    
    # Translation should be different from original
    assert data["translated_text"] != "Hello, how are you?"


@pytest.mark.integration
@pytest.mark.slow
def test_translation_en_to_fr(client):
    """
    Test translation from English to French
    """
    response = client.post(
        "/translate",
        json={
            "text": "Good morning",
            "source_lang": "en",
            "target_lang": "fr"
        }
    )
    
    assert response.status_code == 200
    data = response.json()
    assert "translated_text" in data
    assert len(data["translated_text"]) > 0


@pytest.mark.integration
def test_translation_default_languages(client):
    """
    Test translation with default languages (en -> ar)
    """
    response = client.post(
        "/translate",
        json={"text": "Hello"}
        # source_lang and target_lang will use defaults
    )
    
    assert response.status_code == 200
    data = response.json()
    assert "translated_text" in data


@pytest.mark.integration
def test_translation_empty_text(client):
    """
    Test translation with empty text (should fail)
    """
    response = client.post(
        "/translate",
        json={
            "text": "",
            "source_lang": "en",
            "target_lang": "es"
        }
    )
    
    # Should return validation error
    assert response.status_code == 422


@pytest.mark.integration
def test_translation_invalid_language_code(client):
    """
    Test translation with invalid language code
    """
    response = client.post(
        "/translate",
        json={
            "text": "Hello",
            "source_lang": "invalid",
            "target_lang": "es"
        }
    )
    
    # Should return 422 (validation error) or 400/500 (other error)
    # 422 is the correct response for invalid input
    assert response.status_code in [400, 422, 500]

