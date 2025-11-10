"""
Tests for Named Entity Recognition (NER) endpoint
"""
import pytest


@pytest.mark.integration
def test_ner_extraction(client, sample_entities_text):
    """
    Test NER extracts entities correctly
    """
    response = client.post(
        "/ner",
        json={"text": sample_entities_text}
    )
    
    assert response.status_code == 200
    data = response.json()
    
    # Check response structure
    assert "entities" in data
    assert "text" in data
    assert data["text"] == sample_entities_text
    
    # Check entities were found
    assert len(data["entities"]) > 0
    
    # Check entity structure
    for entity in data["entities"]:
        assert "text" in entity
        assert "label" in entity
        assert "score" in entity
        assert 0 <= entity["score"] <= 1


@pytest.mark.integration
def test_ner_finds_organization(client):
    """
    Test NER finds organization entities
    """
    text = "Microsoft and Google are tech companies."
    response = client.post("/ner", json={"text": text})
    
    assert response.status_code == 200
    data = response.json()
    
    # Should find at least one organization
    entities = data["entities"]
    org_entities = [e for e in entities if "ORG" in e["label"]]
    assert len(org_entities) > 0


@pytest.mark.integration
def test_ner_finds_person(client):
    """
    Test NER finds person entities
    """
    text = "Elon Musk and Bill Gates are famous entrepreneurs."
    response = client.post("/ner", json={"text": text})
    
    assert response.status_code == 200
    data = response.json()
    
    # Should find at least one person
    entities = data["entities"]
    person_entities = [e for e in entities if "PER" in e["label"]]
    assert len(person_entities) > 0


@pytest.mark.integration
def test_ner_finds_location(client):
    """
    Test NER finds location entities
    """
    text = "New York and London are major cities."
    response = client.post("/ner", json={"text": text})
    
    assert response.status_code == 200
    data = response.json()
    
    # Should find at least one location
    entities = data["entities"]
    loc_entities = [e for e in entities if "LOC" in e["label"]]
    assert len(loc_entities) > 0


@pytest.mark.integration
def test_ner_no_entities(client):
    """
    Test NER with text that has no entities
    """
    text = "This is a simple sentence with no entities."
    response = client.post("/ner", json={"text": text})
    
    assert response.status_code == 200
    data = response.json()
    
    # Might find zero entities or misidentify something
    assert "entities" in data
    assert isinstance(data["entities"], list)

