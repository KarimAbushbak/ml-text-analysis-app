# LinguaSense 📱

A beautiful, modern Flutter app for comprehensive text analysis with multiple NLP features. Built with Material 3 and a playful multicolor theme.

## ✨ Features

### Core Features
- **Sentiment Analysis** - Analyze the emotional tone of your text
- **Translation** - Translate text between multiple languages
- **Paraphrasing** - Rephrase text while maintaining meaning
- **Named Entity Recognition** - Extract entities like names, locations, dates
- **Text Summarization** - Condense long text into summaries
- **History** - View past analyses
- **Settings** - Customize your experience

### Design Highlights
- 🎨 Beautiful Material 3 design with multicolor playful theme
- 🌓 Light & dark mode support
- 📱 Modern, clean UI with smooth animations
- 🔄 Reusable components for consistency
- 🎯 Intuitive navigation with GoRouter

## 🏗️ Project Structure

```
lib/
├── core/
│   ├── theme/
│   │   ├── app_colors.dart      # Color palette
│   │   └── app_theme.dart       # Light/dark themes
│   ├── routing/
│   │   └── app_router.dart      # Navigation setup
│   ├── utils/
│   │   └── api_client.dart      # HTTP client utility
│   └── widgets/
│       ├── primary_button.dart      # Gradient button
│       ├── text_input_field.dart    # Multiline input
│       ├── feature_card.dart        # Feature card UI
│       ├── result_card.dart         # Result display
│       └── loading_indicator.dart   # Loading animation
├── features/
│   ├── splash/
│   ├── home/
│   ├── sentiment/
│   ├── translation/
│   ├── paraphrasing/
│   ├── ner/
│   ├── summarization/
│   ├── history/
│   └── settings/
└── main.dart
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.9.2)
- Dart SDK
- Android Studio / VS Code
- iOS Simulator / Android Emulator (for mobile testing)

### Installation

1. Clone the repository:
```bash
git clone <your-repo-url>
cd nlp_flutter_app
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## 🛠️ Tech Stack

### Core
- **Flutter** - UI framework
- **Dart** - Programming language
- **Material 3** - Design system

### State Management
- **flutter_bloc** - BLoC pattern for state management

### Navigation
- **go_router** - Declarative routing

### UI/UX
- **google_fonts** - Inter font family
- **Custom theming** - Light & dark modes

### Networking
- **http** - HTTP client (ready for API integration)

### Storage
- **shared_preferences** - Local data persistence

## 📊 Architecture

### State Management Pattern
The app uses the **BLoC (Business Logic Component)** pattern:

```
UI → Cubit → Service → API
```

### Feature-Based Structure
Each feature has its own folder containing:
- Screen/widget components
- Cubit (state management)
- Models (data classes)
- Services (API calls)
- States (state definitions)

### Reusable Components
Core widgets in `core/widgets/` for consistency:
- **PrimaryButton** - Gradient action buttons
- **TextInputField** - Multiline text inputs
- **FeatureCard** - Home dashboard cards
- **ResultCard** - Display analysis results
- **LoadingIndicator** - Loading animations

## 🎨 Customization

### Theming
Modify colors and themes in:
- `lib/core/theme/app_colors.dart` - Color palette
- `lib/core/theme/app_theme.dart` - Theme configuration

### Adding Features
1. Create feature folder in `lib/features/`
2. Add screen, cubit, models, services
3. Register route in `lib/core/routing/app_router.dart`

## 🔌 API Integration

The app is ready for backend integration:

1. Configure API base URL in `lib/core/utils/api_client.dart`
2. Implement services in feature folders (see `sentiment_service.dart` example)
3. Update cubits to call actual API endpoints

Current implementation uses dummy data for demonstration.

## 📱 Supported Platforms

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Desktop (Windows, macOS, Linux)

## 🧪 Testing

Run tests:
```bash
flutter test
```

Run with coverage:
```bash
flutter test --coverage
```

## 🐛 Debugging

Analyze code:
```bash
flutter analyze
```

Format code:
```bash
flutter format lib/
```

## 📝 TODO

- [ ] Connect to actual NLP backend API
- [ ] Implement real-time text analysis
- [ ] Add history persistence
- [ ] Implement user authentication
- [ ] Add offline mode support
- [ ] Optimize performance
- [ ] Add unit/widget tests
- [ ] Add integration tests

## 🤝 Contributing

Contributions are welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License.

## 👨‍💻 Author

Built with ❤️ by the LinguaSense team

---

**Note**: This is a UI/UX-focused implementation. Backend integration is required for full functionality.
