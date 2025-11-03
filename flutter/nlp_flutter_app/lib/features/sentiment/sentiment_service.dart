import 'package:lingua_sense/features/sentiment/sentiment_model.dart';

import '../../core/utils/api_client.dart';

/// Service for sentiment analysis API calls
class SentimentService {
  Future<SentimentResult> analyzeSentiment({required String text}) async {
    try {
      final response = await ApiClient.post(
        endpoint: '/analyze',
        body: {'text': text},
      );

      return SentimentResult(
        sentiment: response['sentiment'] as String,
        confidence: (response['confidence'] as num).toDouble(),
      );
    } catch (e) {
      throw Exception('Failed to analyze sentiment: $e');
    }
  }
}
