class ParaphraseResult {
  final String originalText;
  final String paraphrasedText;

  ParaphraseResult({
    required this.originalText,
    required this.paraphrasedText,
  });

  factory ParaphraseResult.fromJson(Map<String, dynamic> json, String originalText) {
    return ParaphraseResult(
      originalText: originalText,
      paraphrasedText: json['paraphrased_text'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'original_text': originalText,
      'paraphrased_text': paraphrasedText,
    };
  }
}



