import '../../core/utils/api_client.dart';

/// Entity model for NER results
class Entity {
  final String name;
  final String type;

  Entity({required this.name, required this.type});

  factory Entity.fromJson(Map<String, dynamic> json) {
    return Entity(
      name: json['name'] as String? ?? json['text'] as String? ?? '',
      type: json['type'] as String? ?? json['label'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
    };
  }
}

/// Service for Named Entity Recognition API calls
class NERService {
  /// Recognizes named entities in the given text
  Future<List<Entity>> recognizeEntities(String text) async {
    try {
      final response = await ApiClient.post(
        endpoint: '/ner',
        body: {'text': text},
      );
      
      // NERResponse - check the actual field name in your backend model
      final entitiesData = response['entities'] as List<dynamic>? ?? 
                          response['result'] as List<dynamic>? ?? [];
      
      return entitiesData
          .map((item) => Entity.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to recognize entities: $e');
    }
  }
}

