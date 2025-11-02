import '../../core/utils/api_client.dart';
import 'translation_model.dart'; // Add this

class TranslationService {
  Future<TranslationResult> translate({ // Change return type
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

      // Backend might not return source/target lang, so we pass them
      return TranslationResult(
        translatedText: response['translated_text'] as String,
        sourceLang: sourceLang,
        targetLang: targetLang,
      );
    } catch (e) {
      throw Exception('Failed to translate text: $e');
    }
  }
}