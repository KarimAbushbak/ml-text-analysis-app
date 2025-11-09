import '../../core/utils/api_client.dart';
import '../../core/exceptions/api_exceptions.dart';

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
    } on NetworkException {
      rethrow; // Pass network exceptions up to be handled by UI
    } on TimeoutException {
      rethrow; // Pass timeout exceptions up to be handled by UI
    } on ServerException {
      rethrow; // Pass server exceptions up to be handled by UI
    } catch (e) {
      throw UnknownException('Failed to summarize text: $e');
    }
  }
}
