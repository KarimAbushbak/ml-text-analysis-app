# NLP Analysis Backend API

A FastAPI-based backend service for sentiment analysis, Named Entity Recognition (NER), and translation using Hugging Face transformers.

## Features

- **Real-time sentiment analysis** using state-of-the-art transformer models
- **Named Entity Recognition (NER)** to extract entities like people, organizations, locations
- **Translation** between multiple languages
- **RESTful API** with FastAPI for high performance
- **CORS enabled** for Flutter app integration
- **Batch processing** for multiple texts
- **Health monitoring** endpoints
- **Comprehensive error handling**
- **Clean architecture** with separation of concerns

## Project Structure

```
sentimant/
├── main.py                      # FastAPI application entry point
├── run_server.py                # Server startup script
├── requirements.txt             # Python dependencies
├── README.md                    # This file
└── lib/
    ├── __init__.py
    ├── models.py                # Pydantic data models
    ├── services.py              # Business logic services
    ├── routes.py                # API route definitions
    └── providers/
        ├── __init__.py
        └── model_providers.py   # Model loading and management
```

### Architecture

- **Models** (`lib/models.py`): Pydantic models for request/response validation
- **Providers** (`lib/providers/`): Model loading and management logic
- **Services** (`lib/services.py`): Business logic for NLP operations
- **Routes** (`lib/routes.py`): API endpoint definitions
- **Main** (`main.py`): Application initialization and configuration

## Installation

1. **Create a virtual environment (recommended):**
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

2. **Install Python dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

3. **Run the server:**
   ```bash
   python main.py
   ```
   
   Or using the convenience script:
   ```bash
   python run_server.py
   ```
   
   Or using uvicorn directly:
   ```bash
   uvicorn main:app --host 0.0.0.0 --port 8000 --reload
   ```

## API Endpoints

### Health Check
- **GET** `/` - Basic API status
- **GET** `/health` - Detailed health check including model status

### Sentiment Analysis
- **POST** `/analyze` - Analyze sentiment of a single text
- **POST** `/analyze-batch` - Analyze sentiment of multiple texts

### Named Entity Recognition
- **POST** `/ner` - Extract named entities from text

### Translation
- **POST** `/translate` - Translate text between languages

## Usage Examples

### Single Text Analysis

**Request:**
```bash
curl -X POST "http://localhost:8000/analyze" \
     -H "Content-Type: application/json" \
     -d '{"text": "I love this product! It works perfectly."}'
```

**Response:**
```json
{
  "sentiment": "Positive",
  "confidence": 0.9998,
  "all_scores": [
    {"label": "LABEL_0", "score": 0.0002},
    {"label": "LABEL_1", "score": 0.9998},
    {"label": "LABEL_2", "score": 0.0000}
  ]
}
```

### Named Entity Recognition

**Request:**
```bash
curl -X POST "http://localhost:8000/ner" \
     -H "Content-Type: application/json" \
     -d '{"text": "Apple Inc. is located in Cupertino, California. Tim Cook is the CEO."}'
```

**Response:**
```json
{
  "entities": [
    {
      "text": "Apple Inc.",
      "label": "ORG",
      "score": 0.995
    },
    {
      "text": "Cupertino",
      "label": "LOC",
      "score": 0.987
    },
    {
      "text": "California",
      "label": "LOC",
      "score": 0.992
    },
    {
      "text": "Tim Cook",
      "label": "PER",
      "score": 0.998
    }
  ],
  "text": "Apple Inc. is located in Cupertino, California. Tim Cook is the CEO."
}
```

### Batch Analysis

**Request:**
```bash
curl -X POST "http://localhost:8000/analyze-batch" \
     -H "Content-Type: application/json" \
     -d '{"texts": ["I love this!", "This is terrible.", "It is okay."]}'
```

**Response:**
```json
{
  "results": [
    {
      "text": "I love this!",
      "sentiment": "Positive",
      "confidence": 0.9998
    },
    {
      "text": "This is terrible.",
      "sentiment": "Negative",
      "confidence": 0.9995
    },
    {
      "text": "It is okay.",
      "sentiment": "Neutral",
      "confidence": 0.9876
    }
  ]
}
```

### Translation

**Request:**
```bash
curl -X POST "http://localhost:8000/translate" \
     -H "Content-Type: application/json" \
     -d '{"text": "Hello, how are you?", "source_lang": "en", "target_lang": "ar"}'
```

**Response:**
```json
{
  "translated_text": "مرحبا، كيف حالك؟"
}
```

## Model Information

### Sentiment Analysis
- **Model**: `cardiffnlp/twitter-roberta-base-sentiment-latest`
- **Purpose**: Optimized for social media text (perfect for mobile app sentiment analysis)
- **Speed**: Fast and lightweight for real-time processing
- **Accuracy**: Highly accurate for general sentiment analysis tasks

### Named Entity Recognition
- **Model**: `dslim/bert-base-NER`
- **Entities**: Person (PER), Organization (ORG), Location (LOC), Misc (MISC)
- **Purpose**: Extract structured information from unstructured text
- **Speed**: Efficient processing with BERT-based architecture

### Translation
- **Model**: `Helsinki-NLP/opus-mt-{source}-{target}`
- **Purpose**: Machine translation between language pairs
- **Supported**: Multiple language pairs (en-ar, en-fr, etc.)

## Integration with Flutter

The API is configured with CORS to work seamlessly with Flutter apps. Use the base URL `http://localhost:8000` for local development or your deployed server URL for production.

### Flutter HTTP Request Examples

**Sentiment Analysis:**
```dart
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>> analyzeSentiment(String text) async {
  final response = await http.post(
    Uri.parse('http://localhost:8000/analyze'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({'text': text}),
  );
  
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to analyze sentiment');
  }
}
```

**Named Entity Recognition:**
```dart
Future<Map<String, dynamic>> extractEntities(String text) async {
  final response = await http.post(
    Uri.parse('http://localhost:8000/ner'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({'text': text}),
  );
  
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to extract entities');
  }
}
```

## Error Handling

The API includes comprehensive error handling for:
- Empty or invalid input text
- Model loading failures
- Network connectivity issues
- Server errors

All errors return appropriate HTTP status codes and descriptive error messages.

## Performance

- **Model loading**: ~5-10 seconds on first startup (both models)
- **Analysis speed**: 
  - Sentiment: ~100-500ms per text
  - NER: ~200-800ms per text
  - Translation: ~500-1500ms per text
- **Memory usage**: ~2-3GB RAM (for all transformer models)
- **Concurrent requests**: Handles multiple requests efficiently

## Development

For development with auto-reload:
```bash
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

The API will automatically reload when you make changes to the code.

### Adding New Features

The clean architecture makes it easy to add new features:

1. Add new models in `lib/models.py`
2. Create a model provider in `lib/providers/model_providers.py`
3. Implement business logic in `lib/services.py`
4. Add routes in `lib/routes.py`
5. Register the model and service in `main.py`

## License

MIT License

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
