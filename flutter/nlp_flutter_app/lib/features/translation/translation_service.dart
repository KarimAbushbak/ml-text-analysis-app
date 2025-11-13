import '../../core/utils/api_client.dart';
import '../../core/exceptions/api_exceptions.dart';
import '../../core/constants/api_constants.dart';
import 'translation_model.dart';

class TranslationService {
  Future<TranslationResult> translate({
    required String text,
    required String sourceLang,
    required String targetLang,
  }) async {
    try {
      final response = await ApiClient.post(
        endpoint: ApiConstants.endpointTranslate,
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
    } on NetworkException {
      rethrow; // Pass network exceptions up to be handled by UI
    } on TimeoutException {
      rethrow; // Pass timeout exceptions up to be handled by UI
    } on ServerException {
      rethrow; // Pass server exceptions up to be handled by UI
    } catch (e) {
      throw UnknownException('Failed to translate text: $e');
    }
  }
}