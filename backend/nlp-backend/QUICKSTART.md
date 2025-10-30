# Quick Start Guide

Get up and running with the NLP Analysis API in minutes!

## Prerequisites

- Python 3.8 or higher
- pip package manager

## Installation Steps

### 1. Clone or Navigate to Project

```bash
cd sentimant
```

### 2. Create Virtual Environment (Recommended)

**Windows:**
```bash
python -m venv venv
venv\Scripts\activate
```

**Linux/Mac:**
```bash
python -m venv venv
source venv/bin/activate
```

### 3. Install Dependencies

```bash
pip install -r requirements.txt
```

This will install:
- FastAPI (web framework)
- Uvicorn (ASGI server)
- Transformers (Hugging Face models)
- PyTorch (ML backend)
- Pydantic (data validation)

### 4. Start the Server

```bash
python run_server.py
```

Or:

```bash
python main.py
```

### 5. Verify Installation

Open your browser and visit:

- **API Status**: http://localhost:8000
- **Interactive Docs**: http://localhost:8000/docs
- **Alternative Docs**: http://localhost:8000/redoc
- **Health Check**: http://localhost:8000/health

## First API Call

### Using cURL

**Sentiment Analysis:**
```bash
curl -X POST "http://localhost:8000/analyze" \
     -H "Content-Type: application/json" \
     -d "{\"text\": \"I love this API!\"}"
```

**Named Entity Recognition:**
```bash
curl -X POST "http://localhost:8000/ner" \
     -H "Content-Type: application/json" \
     -d "{\"text\": \"Apple Inc. is located in Cupertino, California.\"}"
```

**Translation:**
```bash
curl -X POST "http://localhost:8000/translate" \
     -H "Content-Type: application/json" \
     -d "{\"text\": \"Hello world\", \"source_lang\": \"en\", \"target_lang\": \"ar\"}"
```

### Using Python

```python
import requests

# Sentiment Analysis
response = requests.post(
    "http://localhost:8000/analyze",
    json={"text": "I love this API!"}
)
print(response.json())

# NER
response = requests.post(
    "http://localhost:8000/ner",
    json={"text": "Apple Inc. is in Cupertino, California."}
)
print(response.json())

# Translation
response = requests.post(
    "http://localhost:8000/translate",
    json={
        "text": "Hello world",
        "source_lang": "en",
        "target_lang": "ar"
    }
)
print(response.json())
```

### Using Interactive Docs

1. Open http://localhost:8000/docs in your browser
2. Click on any endpoint (e.g., "/analyze")
3. Click "Try it out"
4. Enter your text in the JSON body
5. Click "Execute"
6. See the response below

## What's Next?

- Read the [README.md](README.md) for detailed API documentation
- Check [ARCHITECTURE.md](ARCHITECTURE.md) to understand the codebase
- Explore the `lib/` directory structure
- Try different text samples
- Test batch processing

## Troubleshooting

### Models Not Loading

**Problem**: Long startup time or model loading errors

**Solutions**:
- Ensure stable internet connection (models download on first use)
- Free up disk space (models are ~500MB each)
- Check system RAM (models require ~2-3GB)

### Port Already in Use

**Problem**: `Address already in use` error

**Solutions**:
```bash
# Change port in main.py or run_server.py
uvicorn main:app --port 8001
```

### Import Errors

**Problem**: Module not found errors

**Solutions**:
- Ensure you're in the correct directory
- Activate virtual environment
- Reinstall requirements: `pip install -r requirements.txt`

### Slow Response Times

**Problem**: API responses are slow

**Solutions**:
- First request is always slower (cold start)
- Consider using GPU if available
- Check system resources
- Optimize batch size for large datasets

## Common Use Cases

### Analyze Product Reviews

```python
reviews = [
    "This product is amazing!",
    "Terrible quality, disappointed.",
    "It's okay, nothing special."
]

for review in reviews:
    response = requests.post(
        "http://localhost:8000/analyze",
        json={"text": review}
    )
    sentiment = response.json()
    print(f"Review: {review}")
    print(f"Sentiment: {sentiment['sentiment']} ({sentiment['confidence']})")
```

### Extract Business Information

```python
text = "Apple Inc. CEO Tim Cook announced new products at WWDC in Cupertino, California."

response = requests.post(
    "http://localhost:8000/ner",
    json={"text": text}
)

entities = response.json()
for entity in entities['entities']:
    print(f"{entity['label']}: {entity['text']} ({entity['score']})")
```

### Batch Processing

```python
texts = [
    "I love Python!",
    "FastAPI is great!",
    "Python is the best!"
]

response = requests.post(
    "http://localhost:8000/analyze-batch",
    json={"texts": texts}
)

results = response.json()
for result in results['results']:
    print(f"{result['text']}: {result['sentiment']}")
```

## Tips for Best Performance

1. **Use Batch Endpoints**: For multiple texts, use `/analyze-batch`
2. **Cache Results**: Don't re-analyze the same text
3. **Keep Server Running**: Model loading is expensive
4. **Monitor Memory**: Close unused connections
5. **Use Async**: For concurrent requests

## Need Help?

- Check the [README.md](README.md) for detailed documentation
- Review [ARCHITECTURE.md](ARCHITECTURE.md) for code structure
- Examine error messages in the server logs
- Use the interactive docs at `/docs` for API exploration

Happy analyzing! 🚀

