class TranslationResponse {
  final String translatedText;

  TranslationResponse({
    required this.translatedText,
  });

  factory TranslationResponse.fromJson(Map<String, dynamic> json) {
    return TranslationResponse(
      translatedText: json['translated_text'],
    );
  }
}

