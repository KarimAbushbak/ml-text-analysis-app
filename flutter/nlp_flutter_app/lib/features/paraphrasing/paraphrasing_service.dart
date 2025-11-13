import '../../core/utils/api_client.dart';
import '../../core/exceptions/api_exceptions.dart';
import '../../core/constants/api_constants.dart';

/// Service for paraphrasing API calls
class ParaphrasingService {
  /// Paraphrases the given text
  Future<String> paraphrase(String text) async {
    try {
      final response = await ApiClient.post(
        endpoint: ApiConstants.endpointParaphrase,
        body: {'text': text},
      );
      
      // ParaphraseResponse model - check the actual field name in your backend
      final result = response['paraphrased_text'] as String;
      return result;
    } on NetworkException {
      rethrow; // Pass network exceptions up to be handled by UI
    } on TimeoutException {
      rethrow; // Pass timeout exceptions up to be handled by UI
    } on ServerException {
      rethrow; // Pass server exceptions up to be handled by UI
    } catch (e) {
      throw UnknownException('Failed to paraphrase text: $e');
    }
  }
}

