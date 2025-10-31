import '../../core/utils/api_client.dart';

/// Service for translation API calls
class TranslationService {
  /// Translates text from source language to target language
  Future<String> translate({
    required String text,
    required String sourceLang,
    required String targetLang,
  }) async {
    try {
      final response = await ApiClient.post(
        endpoint: '/translate',
        body: {
          'text': text,
          'source_lang': sourceLang,
          'target_lang': targetLang,
        },
      );
      
      // TranslationResponse uses 'translated_text' field
      final result = response['translated_text'] as String? ?? 
                     response['result'] as String?;
      if (result == null) {
        throw Exception('Invalid response format');
      }
      return result;
    } catch (e) {
      throw Exception('Failed to translate text: $e');
    }
  }
}

