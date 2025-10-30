# Architecture Documentation

## Overview

The NLP Analysis API follows a clean architecture pattern with clear separation of concerns. This document explains the structure and design decisions.

## Directory Structure

```
sentimant/
├── main.py                      # Application entry point
├── run_server.py                # Server startup script
├── requirements.txt             # Dependencies
├── README.md                    # User documentation
├── ARCHITECTURE.md              # This file
└── lib/                         # Core application code
    ├── __init__.py
    ├── models.py                # Data models/schemas
    ├── services.py              # Business logic
    ├── routes.py                # API routes
    └── providers/               # Model management
        ├── __init__.py
        └── model_providers.py   # Model providers
```

## Architecture Layers

### 1. Models Layer (`lib/models.py`)

**Responsibility**: Define data structures using Pydantic for:
- Request validation
- Response serialization
- Type safety

**Key Models**:
- `TextInput`: Input for text-based operations
- `BatchTextInput`: Input for batch processing
- `SentimentResponse`: Sentiment analysis output
- `NERResponse`: Named Entity Recognition output
- `TranslationResponse`: Translation output
- `Entity`: Individual entity structure

### 2. Providers Layer (`lib/providers/model_providers.py`)

**Responsibility**: Model loading, initialization, and prediction

**Design Pattern**: Provider pattern

**Key Components**:

#### `ModelProvider` (Base Class)
- Abstract base for all model providers
- Defines interface: `load_model()`, `predict()`, `is_loaded()`

#### `SentimentModelProvider`
- Manages sentiment analysis models
- Default: `cardiffnlp/twitter-roberta-base-sentiment-latest`
- Handles model loading errors with fallback

#### `NERModelProvider`
- Manages Named Entity Recognition models
- Default: `dslim/bert-base-NER`
- Returns aggregated entities

#### `TranslationModelProvider`
- Manages translation models
- Lazy loads models per language pair
- Caches loaded models in memory

### 3. Services Layer (`lib/services.py`)

**Responsibility**: Business logic and data transformation

**Key Services**:

#### `SentimentService`
- Analyzes sentiment using `SentimentModelProvider`
- Formats results into `SentimentResponse`
- Maps model labels to user-friendly format
- Handles batch processing

#### `NERService`
- Extracts entities using `NERModelProvider`
- Converts raw predictions to `Entity` objects
- Returns structured `NERResponse`

#### `TranslationService`
- Translates text using `TranslationModelProvider`
- Manages language pair selection
- Returns clean translation text

### 4. Routes Layer (`lib/routes.py`)

**Responsibility**: API endpoint definitions and HTTP handling

**Features**:
- FastAPI dependency injection for services
- Error handling and HTTP exceptions
- Request/response model validation

**Endpoints**:
- `GET /`: Basic status
- `GET /health`: Health check with model status
- `POST /analyze`: Sentiment analysis
- `POST /analyze-batch`: Batch sentiment analysis
- `POST /ner`: Named Entity Recognition
- `POST /translate`: Translation

### 5. Application Layer (`main.py`)

**Responsibility**: Application initialization and configuration

**Key Responsibilities**:
- FastAPI app creation
- CORS configuration
- Model provider initialization
- Service initialization
- Model loading on startup
- Router registration

## Data Flow

```
Client Request
    ↓
FastAPI Routes (lib/routes.py)
    ↓
Service Layer (lib/services.py)
    ↓
Model Provider (lib/providers/model_providers.py)
    ↓
Hugging Face Transformers
    ↓
Raw Prediction
    ↓
Service Layer (data transformation)
    ↓
Pydantic Model (validation)
    ↓
JSON Response to Client
```

## Design Principles

### 1. Separation of Concerns
- Each layer has a single, well-defined responsibility
- Models don't contain business logic
- Providers don't know about services
- Routes don't contain business logic

### 2. Dependency Injection
- Services injected into routes via FastAPI dependencies
- Enables easy testing and mocking
- Loose coupling between components

### 3. Clean Interfaces
- Abstract base classes define contracts
- Consistent method signatures
- Type hints throughout

### 4. Error Handling
- Comprehensive exception handling at each layer
- User-friendly error messages
- Proper HTTP status codes

### 5. Model Management
- Lazy loading for translation models
- Eager loading for core models (sentiment, NER)
- Caching to avoid redundant loads

## Extension Points

### Adding a New Model Type

1. **Create Provider** (`lib/providers/model_providers.py`):
```python
class NewModelProvider(ModelProvider):
    def __init__(self, model_name: str = "model/path"):
        super().__init__()
        self.model_name = model_name
    
    def load_model(self):
        # Load model logic
        pass
    
    def predict(self, text: str):
        # Prediction logic
        pass
```

2. **Create Service** (`lib/services.py`):
```python
class NewModelService:
    def __init__(self, model_provider: NewModelProvider):
        self.model_provider = model_provider
    
    def process(self, text: str) -> ResponseModel:
        # Business logic
        pass
```

3. **Add Route** (`lib/routes.py`):
```python
@router.post("/new-endpoint", response_model=ResponseModel)
async def new_endpoint(
    input_data: InputModel,
    service: NewModelService = Depends(get_new_model_service)
):
    return service.process(input_data.text)
```

4. **Register in main.py**:
```python
new_model = NewModelProvider()
new_service = NewModelService(new_model)
# Add to routes
```

### Adding a New Endpoint

1. Create route in `lib/routes.py`
2. Use dependency injection for services
3. Define request/response models in `lib/models.py`
4. Router automatically picks it up

## Testing Strategy

### Unit Tests
- Test each service independently
- Mock model providers
- Test data transformations

### Integration Tests
- Test full request/response cycle
- Use test fixtures
- Verify model outputs

### Load Tests
- Test batch processing
- Test concurrent requests
- Measure response times

## Deployment Considerations

### Model Loading
- First request may be slow (cold start)
- Consider warming up models on startup
- Monitor memory usage

### Caching
- Translation models cached in memory
- Consider Redis for distributed caching
- Cache predictions for frequently used texts

### Scaling
- Stateless design enables horizontal scaling
- Consider model server separation
- Use load balancing

## Future Enhancements

1. **Model Registry**: Centralized model management
2. **Async Processing**: Background task queue for long operations
3. **Model Versioning**: Support multiple model versions
4. **Metrics**: Prometheus metrics integration
5. **Auth**: API key authentication
6. **Rate Limiting**: Request rate limiting
7. **Batch Processing**: Async batch job processing
8. **Model A/B Testing**: Compare model performance

## Performance Optimizations

1. **Model Quantization**: Reduce model size and speed
2. **TensorRT/ONNX**: Faster inference
3. **Batching**: Process multiple texts together
4. **GPU Support**: CUDA acceleration
5. **Connection Pooling**: Efficient database connections
6. **Response Caching**: Cache frequent requests

## Security Considerations

1. **Input Validation**: All inputs validated via Pydantic
2. **Rate Limiting**: Prevent abuse
3. **CORS**: Configured for Flutter app
4. **Logging**: Comprehensive logging for audit
5. **Error Messages**: Don't expose internal details

