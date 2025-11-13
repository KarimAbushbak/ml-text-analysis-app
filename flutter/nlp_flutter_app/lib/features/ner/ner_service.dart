import '../../core/utils/api_client.dart';
import '../../core/exceptions/api_exceptions.dart';
import '../../core/constants/api_constants.dart';
import 'ner_model.dart';

class NERService {
  /// Recognizes named entities in the given text
  Future<List<NerResult>> recognizeEntities({required String text}) async {
    try {
      final response = await ApiClient.post(
        endpoint: ApiConstants.endpointNER,
        body: {'text': text},
      );
      
      final entitiesList = response['entities'] as List<dynamic>;
      return entitiesList
          .map((entity) => NerResult.fromJson(entity as Map<String, dynamic>))
          .toList();
    } on NetworkException {
      rethrow; // Pass network exceptions up to be handled by UI
    } on TimeoutException {
      rethrow; // Pass timeout exceptions up to be handled by UI
    } on ServerException {
      rethrow; // Pass server exceptions up to be handled by UI
    } catch (e) {
      throw UnknownException('Failed to recognize entities: $e');
    }
  }
}

