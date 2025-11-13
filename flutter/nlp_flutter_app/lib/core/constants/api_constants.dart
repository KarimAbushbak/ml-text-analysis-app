/// Centralized API constants for URLs and endpoints
/// All API-related constants should be defined here
class ApiConstants {
  ApiConstants._(); // Private constructor to prevent instantiation

  // Base URLs
  static const bool useProduction = true;
  static const String productionUrl = 'https://karim323-nlp-analysis-api.hf.space';
  static const String localUrlAndroid = 'http://10.0.2.2:8000';
  static const String localUrlIOS = 'http://localhost:8000';
  static const String localUrlDesktop = 'http://localhost:8000';

  // API Endpoints
  static const String endpointAnalyze = '/analyze';
  static const String endpointNER = '/ner';
  static const String endpointTranslate = '/translate';
  static const String endpointParaphrase = '/paraphrase';
  static const String endpointSummarize = '/summarize';
  static const String endpointHealth = '/health';
  static const String endpointRoot = '/';

  // API Headers
  static const String headerContentType = 'Content-Type';
  static const String headerContentTypeJson = 'application/json';
  static const String headerApiKey = 'X-API-Key';

  // API Timeouts
  static const Duration requestTimeout = Duration(seconds: 30);
  static const int maxRetries = 3;
  static const Duration initialRetryDelay = Duration(seconds: 1);

  // Route Paths (for navigation)
  static const String routeSplash = '/splash';
  static const String routeHome = '/home';
  static const String routeSentiment = '/sentiment';
  static const String routeTranslation = '/translation';
  static const String routeParaphrasing = '/paraphrasing';
  static const String routeNER = '/ner';
  static const String routeSummarization = '/summarization';
  static const String routeHistory = '/history';
  static const String routeSettings = '/settings';

  // Route Names (for named navigation)
  static const String routeNameSplash = 'splash';
  static const String routeNameHome = 'home';
  static const String routeNameSentiment = 'sentiment';
  static const String routeNameTranslation = 'translation';
  static const String routeNameParaphrasing = 'paraphrasing';
  static const String routeNameNER = 'ner';
  static const String routeNameSummarization = 'summarization';
  static const String routeNameHistory = 'history';
  static const String routeNameSettings = 'settings';
}

