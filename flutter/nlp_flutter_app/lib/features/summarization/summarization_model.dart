class SummarizationResult {
  final String originalText;
  final String summary;

  SummarizationResult({
    required this.originalText,
    required this.summary,
  });

  factory SummarizationResult.fromJson(
    Map<String, dynamic> json,
    String originalText,
  ) {
    return SummarizationResult(
      originalText: originalText,
      summary: json['summary_text'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'original_text': originalText,
      'summary': summary,
    };
  }
}

