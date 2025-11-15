# LinguaSense - Full-Stack ML Text Analysis App 🚀

A production-ready, full-stack natural language processing application with a beautiful Flutter mobile app and a powerful FastAPI backend. Deployed on Hugging Face Spaces with real-time ML model inference.

![Flutter](https://img.shields.io/badge/Flutter-3.9.2+-02569B?logo=flutter)
![Python](https://img.shields.io/badge/Python-3.11+-3776AB?logo=python)
![FastAPI](https://img.shields.io/badge/FastAPI-0.104.1-009688?logo=fastapi)
![License](https://img.shields.io/badge/License-MIT-green)

## 🌟 Live Demo

- **API**: [https://karim323-nlp-analysis-api.hf.space](https://karim323-nlp-analysis-api.hf.space)
- **API Docs**: [https://karim323-nlp-analysis-api.hf.space/docs](https://karim323-nlp-analysis-api.hf.space/docs)
- **HF Space**: [https://huggingface.co/spaces/karim323/nlp-analysis-api](https://huggingface.co/spaces/karim323/nlp-analysis-api)

## ✨ Features

### 🎯 Core NLP Features
- **Sentiment Analysis** - Analyze emotional tone (positive, negative, neutral) with confidence scores
- **Translation** - Translate text between 12+ languages using Helsinki-NLP models
- **Paraphrasing** - Rephrase text while maintaining original meaning
- **Named Entity Recognition (NER)** - Extract entities (people, locations, organizations, dates, etc.)
- **Text Summarization** - Condense long text into concise summaries

### 📱 Mobile App Features
- **Beautiful Material 3 UI** - Modern, clean design with multicolor playful theme
- **Dark Mode Support** - Seamless light/dark theme switching
- **History Management** - Save and view past analyses with filtering
- **Offline-Ready** - Local storage with SharedPreferences
- **Cross-Platform** - Android, iOS, Web, Desktop support

### 🔒 Backend Features
- **Production-Ready API** - FastAPI with async support
- **Rate Limiting** - Protect against abuse with configurable limits
- **Input Validation** - Comprehensive Pydantic validation
- **Security** - API key authentication, CORS protection
- **Health Monitoring** - Real-time health checks and model status
- **Automated Testing** - Comprehensive test suite with coverage

## 🏗️ Architecture

```
ml-text-analysis-app/
├── backend/
│   └── nlp-backend/          # FastAPI backend service
│       ├── main.py           # Application entry point
│       ├── lib/              # Core application code
│       │   ├── routes.py     # API endpoints
│       │   ├── services.py   # Business logic
│       │   ├── models.py     # Pydantic models
│       │   ├── auth.py       # Authentication
│       │   ├── rate_limiter.py
│       │   └── providers/    # ML model providers
│       ├── tests/            # Test suite
│       └── requirements.txt  # Python dependencies
│
├── flutter/
│   └── nlp_flutter_app/      # Flutter mobile app
│       ├── lib/
│       │   ├── core/         # Core utilities
│       │   │   ├── constants/ # AppStrings, AppDimensions, ApiConstants
│       │   │   ├── theme/     # Theme management (Cubit)
│       │   │   ├── utils/     # API client, network info
│       │   │   └── widgets/   # Reusable widgets
│       │   └── features/      # Feature modules
│       │       ├── sentiment/
│       │       ├── translation/
│       │       ├── paraphrasing/
│       │       ├── ner/
│       │       ├── summarization/
│       │       ├── history/
│       │       └── settings/
│       └── pubspec.yaml      # Flutter dependencies
│
└── hf-space/                  # Hugging Face Spaces deployment
    ├── Dockerfile            # Container configuration
    ├── main.py               # FastAPI app
    └── requirements.txt      # Production dependencies
```

## 🚀 Quick Start

### Prerequisites

- **Python 3.11+** (for backend)
- **Flutter SDK 3.9.2+** (for mobile app)
- **Dart SDK**
- **Git**

### Backend Setup

```bash
# Navigate to backend
cd backend/nlp-backend

# Create virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Set up environment variables
cp .env.example .env
# Edit .env with your configuration

# Run the server
python main.py
# Or use uvicorn directly
uvicorn main:app --reload --port 8000
```

The API will be available at `http://localhost:8000`

**API Documentation**: `http://localhost:8000/docs`

### Flutter App Setup

```bash
# Navigate to Flutter app
cd flutter/nlp_flutter_app

# Install dependencies
flutter pub get

# Run on connected device/emulator
flutter run

# Or build for specific platform
flutter build apk          # Android
flutter build ios          # iOS
flutter build web          # Web
```

### Configuration

#### Backend Environment Variables

Create `.env` file in `backend/nlp-backend/`:

```env
ENVIRONMENT=development
ALLOWED_ORIGINS=http://localhost:8000,http://10.0.2.2:8000,http://127.0.0.1:8000
API_KEY=dev-key-12345-change-in-production
HOST=0.0.0.0
PORT=8000
```

#### Flutter App Configuration

Update API endpoint in `flutter/nlp_flutter_app/lib/core/constants/api_constants.dart`:

```dart
static const bool useProduction = false;  // Set to true for live API
static const String productionUrl = 'https://karim323-nlp-analysis-api.hf.space';
```

## 📚 API Endpoints

### Base URL
- **Production**: `https://karim323-nlp-analysis-api.hf.space`
- **Local**: `http://localhost:8000`

### Endpoints

| Method | Endpoint | Description | Rate Limit |
|--------|----------|-------------|------------|
| `GET` | `/` | API info | 30/min |
| `GET` | `/health` | Health check & model status | 30/min |
| `POST` | `/analyze` | Sentiment analysis | 20/min |
| `POST` | `/ner` | Named Entity Recognition | 20/min |
| `POST` | `/translate` | Text translation | 15/min |
| `POST` | `/paraphrase` | Text paraphrasing | 10/min |
| `POST` | `/summarize` | Text summarization | 10/min |

### Example Request

```bash
curl -X POST "https://karim323-nlp-analysis-api.hf.space/analyze" \
  -H "Content-Type: application/json" \
  -d '{"text": "I love this product!"}'
```

### Example Response

```json
{
  "sentiment": "positive",
  "confidence": 0.9876
}
```

See [API Documentation](https://karim323-nlp-analysis-api.hf.space/docs) for detailed schemas.

## 🛠️ Tech Stack

### Backend
- **FastAPI** - Modern, fast web framework
- **Hugging Face Transformers** - Pre-trained ML models
- **PyTorch** - Deep learning framework
- **Pydantic** - Data validation
- **slowapi** - Rate limiting
- **pytest** - Testing framework

### Frontend
- **Flutter** - Cross-platform UI framework
- **flutter_bloc** - State management (Cubit pattern)
- **go_router** - Declarative routing
- **http** - HTTP client
- **shared_preferences** - Local storage
- **connectivity_plus** - Network connectivity checks

### Deployment
- **Hugging Face Spaces** - ML model hosting
- **Docker** - Containerization
- **GitHub** - Version control

## 🧪 Testing

### Backend Tests

```bash
cd backend/nlp-backend

# Run all tests
python run_tests.py

# Or with pytest directly
pytest

# With coverage
pytest --cov=lib --cov-report=html
```

### Flutter Tests

```bash
cd flutter/nlp_flutter_app

# Run unit tests
flutter test

# Run with coverage
flutter test --coverage
```

## 📦 Deployment

### Hugging Face Spaces

The backend is deployed on Hugging Face Spaces:

1. **Repository**: [karim323/nlp-analysis-api](https://huggingface.co/spaces/karim323/nlp-analysis-api)
2. **Auto-deploy**: Pushes to `main` branch trigger rebuilds
3. **Docker**: Uses custom Dockerfile for optimized builds
4. **Health Checks**: Automatic health monitoring

### Local Deployment

See `backend/nlp-backend/README_DEPLOYMENT.md` for detailed deployment instructions.

## 🔐 Security Features

- ✅ **API Key Authentication** - Protect endpoints with API keys
- ✅ **Rate Limiting** - Prevent abuse with configurable limits
- ✅ **Input Validation** - Comprehensive Pydantic validation
- ✅ **CORS Protection** - Whitelist allowed origins
- ✅ **Environment Variables** - Secure configuration management

## 📱 Mobile App Permissions

### Android
- `INTERNET` - For API calls
- `ACCESS_NETWORK_STATE` - For connectivity checks

### iOS
- Internet access enabled by default
- App Transport Security configured for HTTPS

## 🎨 Design System

### Constants Management
- **AppStrings** - All text strings centralized
- **AppDimensions** - All spacing, padding, sizes
- **ApiConstants** - URLs, endpoints, routes

### Theme
- **Light Mode** - Clean, bright interface
- **Dark Mode** - Optimized dark theme with proper contrast
- **Material 3** - Modern design system

## 📖 Documentation

- [Backend README](backend/nlp-backend/README.md) - Backend documentation
- [Flutter README](flutter/nlp_flutter_app/README.md) - Mobile app documentation
- [API Documentation](https://karim323-nlp-analysis-api.hf.space/docs) - Interactive API docs
- [Architecture Guide](backend/nlp-backend/ARCHITECTURE.md) - System architecture
- [Testing Guide](backend/nlp-backend/TESTING.md) - Testing documentation

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Guidelines

- Follow existing code style
- Add tests for new features
- Update documentation
- Ensure all tests pass
- Follow commit message conventions

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Karim Abushbak**

- GitHub: [@KarimAbushbak](https://github.com/KarimAbushbak)
- Hugging Face: [@karim323](https://huggingface.co/karim323)

## 🙏 Acknowledgments

- **Hugging Face** - For amazing transformer models and Spaces platform
- **FastAPI** - For the excellent web framework
- **Flutter Team** - For the powerful UI framework
- **Open Source Community** - For all the amazing libraries

## 📊 Project Status

- ✅ Backend API - Production ready, deployed on HF Spaces
- ✅ Flutter App - Fully functional, connected to live API
- ✅ Dark Mode - Implemented with ThemeCubit
- ✅ Testing - Comprehensive test coverage
- ✅ Documentation - Complete documentation
- ✅ Deployment - Automated deployment pipeline

## 🐛 Known Issues

- Translation models require `sentencepiece` dependency (now included)
- Large models may take time to load on first request
- Rate limits apply to prevent abuse

## 🔮 Future Enhancements

- [ ] User authentication and profiles
- [ ] Batch processing UI
- [ ] Export history to file
- [ ] Offline mode with cached models
- [ ] More language support
- [ ] Advanced filtering options
- [ ] Analytics dashboard
- [ ] Web app version

---

**Built with ❤️ using Flutter, FastAPI, and Hugging Face Transformers**

For questions or support, please open an issue on GitHub.

