# Test Suite Documentation

## Overview

This test suite provides comprehensive testing for the NLP Backend API, including:
- ✅ API endpoint integration tests
- ✅ Security feature tests
- ✅ Input validation tests
- ✅ Unit tests for models

## Test Organization

```
tests/
├── __init__.py              # Package marker
├── conftest.py              # Shared fixtures (reusable test data)
├── test_health.py           # Health check endpoint tests
├── test_sentiment.py        # Sentiment analysis tests
├── test_ner.py              # Named Entity Recognition tests
├── test_translation.py      # Translation tests
├── test_paraphrase.py       # Paraphrasing tests
├── test_summarization.py    # Summarization tests
├── test_security.py         # Security feature tests
├── test_models.py           # Pydantic model unit tests
└── README.md                # This file
```

## Running Tests

### Run All Tests
```bash
# Using pytest directly
pytest

# Using the test runner script
python run_tests.py
```

### Run Specific Test File
```bash
pytest tests/test_sentiment.py
```

### Run Specific Test Function
```bash
pytest tests/test_sentiment.py::test_sentiment_analysis_positive
```

### Run Tests by Marker
```bash
# Run only unit tests
pytest -m unit

# Run only integration tests
pytest -m integration

# Run only security tests
pytest -m security

# Exclude slow tests
pytest -m "not slow"
```

### Run with Coverage Report
```bash
pytest --cov=lib --cov-report=html
# Open htmlcov/index.html in browser
```

### Run in Verbose Mode
```bash
pytest -v
```

## Test Markers

Tests are organized with markers for easy filtering:

- `@pytest.mark.unit` - Unit tests (test individual functions/classes)
- `@pytest.mark.integration` - Integration tests (test full API endpoints)
- `@pytest.mark.security` - Security feature tests
- `@pytest.mark.slow` - Slow tests (e.g., translation tests that load models)

## Fixtures (Reusable Test Data)

Defined in `conftest.py`:

- `client` - FastAPI test client for making requests
- `sample_texts` - Common text samples (positive, negative, neutral, etc.)
- `sample_entities_text` - Text with named entities for NER testing
- `sample_translation` - Translation test data
- `sample_batch_texts` - Batch of texts for batch testing

## Writing New Tests

### Example: Adding a New Test

```python
import pytest

@pytest.mark.integration
def test_my_new_feature(client):
    """
    Test description here
    """
    response = client.post("/my-endpoint", json={"data": "value"})
    
    assert response.status_code == 200
    data = response.json()
    assert "expected_field" in data
```

### Test Naming Convention

- File: `test_<feature>.py`
- Function: `test_<specific_behavior>`
- Use descriptive names that explain what is being tested

## Coverage Goals

Target: **60%+ code coverage** (configured in pytest.ini)

Current coverage areas:
- ✅ All API endpoints
- ✅ Input validation
- ✅ Security features
- ✅ Pydantic models
- ⚠️ TODO: Service layer unit tests
- ⚠️ TODO: Model provider tests

## Continuous Integration

Tests are designed to run in CI/CD pipelines (GitHub Actions, etc.)

Example GitHub Actions workflow:
```yaml
- name: Run tests
  run: |
    pip install -r requirements.txt
    pip install -r requirements-dev.txt
    pytest
```

## Common Issues

### Issue: "ModuleNotFoundError"
**Solution**: Make sure you're running tests from the `backend/nlp-backend` directory

### Issue: Tests timing out
**Solution**: Slow tests (translation, paraphrase) might timeout on first run while models download. Run them locally first.

### Issue: Rate limiting tests fail
**Solution**: Rate limiting might behave differently in test mode. This is expected.

## Best Practices

1. ✅ Each test should be independent (not rely on other tests)
2. ✅ Use fixtures for common test data
3. ✅ Test both success and failure cases
4. ✅ Keep tests fast (mark slow tests with `@pytest.mark.slow`)
5. ✅ Use descriptive test names
6. ✅ Add docstrings to explain what's being tested
7. ✅ Assert specific expected values, not just "something exists"

## Next Steps

To improve test coverage:
1. Add unit tests for service classes
2. Add tests for model providers
3. Add performance/load tests
4. Add end-to-end tests with real Flutter app

