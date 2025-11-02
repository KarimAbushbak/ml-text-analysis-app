// translation_model.dart
class TranslationResult {
  final String translatedText;
  final String sourceLang;
  final String targetLang;

  TranslationResult({
    required this.translatedText,
    required this.sourceLang,
    required this.targetLang,
  });

  factory TranslationResult.fromJson(Map<String, dynamic> json) {
    return TranslationResult(
      translatedText: json['translated_text'] as String,  // JSON key
      sourceLang: json['source_lang'] as String,         // JSON key
      targetLang: json['target_lang'] as String,         // JSON key
    );
  }
}

