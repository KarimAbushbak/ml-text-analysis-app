class NerResult {
  final String text;
  final String label;
  final double score;

  NerResult({
    required this.text,
    required this.label,
    required this.score,
  });

  factory NerResult.fromJson(Map<String, dynamic> json) {
    return NerResult(
      text: json['text'] as String,
      label: json['label'] as String,
      score: (json['score'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'label': label,
      'score': score,
    };
  }
}
