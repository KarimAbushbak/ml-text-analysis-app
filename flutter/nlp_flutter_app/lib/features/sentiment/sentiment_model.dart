/// Sentiment analysis result model
class SentimentResult {
  final String sentiment; // positive, negative, neutral
  final double confidence; // 0.0 to 1.0

  SentimentResult({
    required this.sentiment,
    required this.confidence,
  });

  factory SentimentResult.fromJson(Map<String, dynamic> json) {
    return SentimentResult(
      sentiment: json['sentiment'] as String,
      confidence: (json['confidence'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sentiment': sentiment,
      'confidence': confidence,
    };
  }
}

