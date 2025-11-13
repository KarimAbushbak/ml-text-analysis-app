import 'package:lingua_sense/features/sentiment/sentiment_model.dart';

import '../../core/utils/api_client.dart';
import '../../core/exceptions/api_exceptions.dart';
import '../../core/constants/api_constants.dart';

/// Service for sentiment analysis API calls
class SentimentService {
  Future<SentimentResult> analyzeSentiment({required String text}) async {
    try {
      final response = await ApiClient.post(
        endpoint: ApiConstants.endpointAnalyze,
        body: {'text': text},
      );

      return SentimentResult(
        sentiment: response['sentiment'] as String,
        confidence: (response['confidence'] as num).toDouble(),
      );
    } on NetworkException {
      rethrow; // Pass network exceptions up to be handled by UI
    } on TimeoutException {
      rethrow; // Pass timeout exceptions up to be handled by UI
    } on ServerException {
      rethrow; // Pass server exceptions up to be handled by UI
    } catch (e) {
      throw UnknownException('Failed to analyze sentiment: $e');
    }
  }
}
