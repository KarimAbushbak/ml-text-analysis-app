import '../../core/utils/api_client.dart';

/// Service for paraphrasing API calls
class ParaphrasingService {
  /// Paraphrases the given text
  Future<String> paraphrase(String text) async {
    try {
      final response = await ApiClient.post(
        endpoint: '/paraphrase',
        body: {'text': text},
      );
      
      // ParaphraseResponse model - check the actual field name in your backend
      final result = response['paraphrased_text'] as String? ?? 
                     response['paraphrase'] as String? ??
                     response['result'] as String?;
      if (result == null) {
        throw Exception('Invalid response format');
      }
      return result;
    } catch (e) {
      throw Exception('Failed to paraphrase text: $e');
    }
  }
}

