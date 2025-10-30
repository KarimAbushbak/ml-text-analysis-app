part of 'sentiment_cubit.dart';

sealed class SentimentState {}

final class SentimentInitial extends SentimentState {}

final class SentimentLoading extends SentimentState {}

final class SentimentLoaded extends SentimentState {
  final String text;
  final String sentiment;
  final double confidence;
  final List<dynamic>? allScores;
  
  SentimentLoaded({
    required this.text,
    required this.sentiment,
    required this.confidence,
    this.allScores,
  });
}

final class SentimentError extends SentimentState {
  final String message;
  SentimentError(this.message);
}
