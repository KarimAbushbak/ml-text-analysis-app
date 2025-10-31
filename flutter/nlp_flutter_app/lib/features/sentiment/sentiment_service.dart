import '../../core/utils/api_client.dart';
import 'sentiment_model.dart';

/// Service for sentiment analysis API calls
class SentimentService {
  /// Analyzes sentiment of the given text
  Future<SentimentResult> analyzeSentiment(String text) async {
    try {
      final response = await ApiClient.post(
        endpoint: '/analyze',
        body: {'text': text},
      );
      
      return SentimentResult.fromJson(response);
    } catch (e) {
      throw Exception('Failed to analyze sentiment: $e');
    }
  }
}

