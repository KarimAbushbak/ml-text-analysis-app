/// Centralized string constants for the entire app
/// All user-facing text should be defined here for easy maintenance and localization
class AppStrings {
  AppStrings._(); // Private constructor to prevent instantiation

  // App Info
  static const String appName = 'LinguaSense';
  static const String appVersion = 'v1.0.0';
  static const String appDescription = 'A beautiful text analysis app with multiple NLP features.';

  // Home Screen
  static const String welcome = 'Welcome! 👋';
  static const String chooseFeature = 'Choose a feature to get started';

  // Feature Labels
  static const String sentimentAnalysis = 'Sentiment\nAnalysis';
  static const String translation = 'Translation';
  static const String paraphrasing = 'Paraphrasing';
  static const String namedEntityRecognition = 'Named Entity\nRecognition';
  static const String summarization = 'Summarization';
  static const String history = 'History';

  // Common Actions
  static const String analyze = 'Analyze';
  static const String translate = 'Translate';
  static const String paraphrase = 'Paraphrase';
  static const String findEntities = 'Find Entities';
  static const String summarize = 'Summarize';
  static const String cancel = 'Cancel';
  static const String close = 'Close';
  static const String retry = 'Retry';
  static const String delete = 'Delete';
  static const String clear = 'Clear';
  static const String clearAll = 'Clear All';
  static const String clearFilter = 'Clear filter';
  static const String all = 'All';
  static const String filter = 'Filter';
  static const String settings = 'Settings';
  static const String about = 'About';
  static const String darkMode = 'Dark Mode';
  static const String toggleDarkTheme = 'Toggle dark theme';

  // Sentiment Screen
  static const String sentimentAnalysisTitle = 'Sentiment Analysis';
  static const String enterTextToAnalyze = 'Enter the text you want to analyze';
  static const String yourText = 'Your Text';
  static const String typeOrPasteText = 'Type or paste your text here...';
  static const String analyzeSentiment = 'Analyze Sentiment';
  static const String sentimentResult = 'Sentiment Result';
  static const String sentiment = 'Sentiment';
  static const String confidence = 'Confidence';
  static const String positive = 'Positive';
  static const String negative = 'Negative';
  static const String neutral = 'Neutral';

  // Translation Screen
  static const String translationTitle = 'Translation';
  static const String from = 'From';
  static const String to = 'To';
  static const String sourceText = 'Source Text';
  static const String enterTextToTranslate = 'Enter text to translate...';
  static const String translation = 'Translation';

  // Paraphrasing Screen
  static const String paraphrasingTitle = 'Paraphrasing';
  static const String enterTextToParaphrase = 'Enter text to paraphrase';
  static const String originalText = 'Original Text';
  static const String enterTextToParaphraseHint = 'Enter text to paraphrase...';
  static const String paraphrasedText = 'Paraphrased Text';

  // NER Screen
  static const String nerTitle = 'Named Entity Recognition';
  static const String enterTextToExtractEntities = 'Enter text to extract named entities';
  static const String enterTextToFindEntities = 'Enter text to find named entities...';
  static const String noEntitiesFound = 'No Entities Found';
  static const String noEntitiesDetected = 'No named entities were detected in the text.';
  static const String foundEntities = 'Found Entities';
  static const String entityPerson = 'Person';
  static const String entityLocation = 'Location';
  static const String entityOrganization = 'Organization';
  static const String entityMisc = 'Misc';
  static const String entityDate = 'Date';
  static const String entityTime = 'Time';
  static const String entityMoney = 'Money';
  static const String entityPercent = 'Percent';

  // Summarization Screen
  static const String summarizationTitle = 'Text Summarization';
  static const String enterTextToSummarize = 'Enter text to summarize';
  static const String enterTextToSummarizeHint = 'Enter text to summarize (minimum 100 characters)...';
  static const String summary = 'Summary';
  static const String originalLength = 'Original length';
  static const String summaryLength = 'Summary length';
  static const String characters = 'characters';

  // History Screen
  static const String historyTitle = 'History';
  static const String clearAllHistory = 'Clear All History';
  static const String deleteAllHistoryConfirm = 'Delete all history? This cannot be undone.';
  static const String historyCleared = 'History cleared';
  static const String deleted = 'Deleted';
  static const String noHistoryYet = 'No history yet';
  static const String pastAnalysesWillAppear = 'Your past analyses will appear here';
  static const String noItemsFound = 'No items found';
  static const String showingFilterOnly = 'Showing';
  static const String only = 'only';
  static const String errorLoadingHistory = 'Error Loading History';
  static const String clearAllTooltip = 'Clear all';

  // History Filter Types
  static const String filterTranslation = 'Translation';
  static const String filterSentiment = 'Sentiment';
  static const String filterParaphrasing = 'Paraphrasing';
  static const String filterNER = 'NER';
  static const String filterSummarization = 'Summarization';

  // Settings Screen
  static const String settingsTitle = 'Settings';
  static const String aboutLinguaSense = 'About LinguaSense';
  static const String features = 'Features';
  static const String featureSentimentAnalysis = '• Sentiment Analysis';
  static const String featureTranslation = '• Translation';
  static const String featureParaphrasing = '• Paraphrasing';
  static const String featureNER = '• Named Entity Recognition';
  static const String featureSummarization = '• Text Summarization';

  // Result Card
  static const String error = 'Error';
  static const String result = 'Result';

  // Common Placeholders
  static const String loading = 'Loading...';
  static const String unknown = 'Unknown';

  // Error Messages
  static const String noInternetConnection = 'No internet connection. Please check your network settings.';
  static const String requestTimedOut = 'Request timed out. Please try again.';
  static const String invalidRequest = 'Invalid request. Please check your input.';
  static const String authenticationFailed = 'Authentication failed. Please login again.';
  static const String accessForbidden = 'Access forbidden.';
  static const String resourceNotFound = 'Resource not found.';
  static const String tooManyRequests = 'Too many requests. Please try again later.';
  static const String serverError = 'Server error. Please try again later.';
  static const String unexpectedError = 'An unexpected error occurred.';
}

