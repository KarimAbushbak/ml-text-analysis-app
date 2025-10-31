import '../../core/utils/api_client.dart';

/// Service for text summarization API calls
class SummarizationService {
  /// Summarizes the given text with specified ratio
  Future<String> summarize({
    required String text,
    double? ratio,
  }) async {
    try {
      // Note: Summarization endpoint may not exist in your backend yet
      final response = await ApiClient.post(
        endpoint: '/summarize',
        body: {
          'text': text,
          if (ratio != null) 'ratio': ratio,
        },
      );
      
      final result = response['summary'] as String? ?? 
                     response['result'] as String?;
      if (result == null) {
        throw Exception('Invalid response format');
      }
      return result;
    } catch (e) {
      throw Exception('Failed to summarize text: $e');
    }
  }
}

