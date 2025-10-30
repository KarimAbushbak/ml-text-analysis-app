class SentimentResponse {
  final String sentiment;
  final double confidence;
  final List<dynamic>? allScores;

  SentimentResponse({
    required this.sentiment,
    required this.confidence,
    this.allScores,
  });

  factory SentimentResponse.fromJson(Map<String, dynamic> json) {
    return SentimentResponse(
      sentiment: json['sentiment'],
      confidence: json['confidence'].toDouble(),
      allScores: json['all_scores'],
    );
  }
}
