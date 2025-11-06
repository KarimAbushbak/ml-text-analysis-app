import '../../core/utils/api_client.dart';

/// Service for text summarization API calls
class SummarizationService {
  /// Summarizes the given text
  Future<String> summarize({required String text}) async {
    try {
      final response = await ApiClient.post(
        endpoint: '/summarize',
        body: {'text': text},
      );

      final result = response['summary_text'] as String;
      return result;
    } catch (e) {
      throw Exception('Failed to summarize text: $e');
    }
  }
}
