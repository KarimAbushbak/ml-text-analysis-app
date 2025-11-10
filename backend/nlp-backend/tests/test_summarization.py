"""
Tests for text summarization endpoint
"""
import pytest


@pytest.mark.integration
@pytest.mark.slow
def test_summarization_basic(client):
    """
    Test text summarization with a longer paragraph
    """
    text = """
    Artificial intelligence has revolutionized many industries in recent years. 
    Machine learning algorithms can now process vast amounts of data and identify 
    patterns that humans might miss. Deep learning, a subset of machine learning, 
    uses neural networks with multiple layers to extract high-level features from 
    raw input. This technology powers many modern applications, from voice assistants 
    to autonomous vehicles. As AI continues to advance, it promises to bring even 
    more transformative changes to society.
    """
    
    response = client.post("/summarize", json={"text": text})
    
    assert response.status_code == 200
    data = response.json()
    
    # Check response structure
    assert "summary_text" in data
    assert len(data["summary_text"]) > 0
    
    # Summary should typically be shorter than original
    assert len(data["summary_text"]) <= len(text)


@pytest.mark.integration
@pytest.mark.slow
def test_summarization_news_article(client):
    """
    Test summarization with news-style text
    """
    text = """
    Technology companies are investing heavily in renewable energy sources. 
    Major corporations have announced plans to power their data centers with 
    solar and wind energy. This shift towards green energy is driven by both 
    environmental concerns and economic benefits. Renewable energy costs have 
    decreased significantly, making it a viable alternative to traditional 
    power sources.
    """
    
    response = client.post("/summarize", json={"text": text})
    
    assert response.status_code == 200
    data = response.json()
    assert "summary_text" in data
    assert len(data["summary_text"]) > 0


@pytest.mark.integration
def test_summarization_short_text(client):
    """
    Test summarization with very short text
    Note: Summarization works best with longer text (100+ words)
    """
    text = "This is a short sentence."
    response = client.post("/summarize", json={"text": text})
    
    # Should still return something (even if not a great summary)
    assert response.status_code == 200
    data = response.json()
    assert "summary_text" in data


@pytest.mark.integration
def test_summarization_empty_text(client):
    """
    Test summarization with empty text (should fail)
    """
    response = client.post("/summarize", json={"text": ""})
    
    # Should return validation error
    assert response.status_code == 422

