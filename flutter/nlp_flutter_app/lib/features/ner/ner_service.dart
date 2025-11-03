import '../../core/utils/api_client.dart';
import 'ner_model.dart';

class NERService {
  /// Recognizes named entities in the given text
  Future<List<NerResult>> recognizeEntities({required String text}) async {
    try {
      final response = await ApiClient.post(
        endpoint: '/ner',
        body: {'text': text},
      );
      
      final entitiesList = response['entities'] as List<dynamic>;
      return entitiesList
          .map((entity) => NerResult.fromJson(entity as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to recognize entities: $e');
    }
  }
}

