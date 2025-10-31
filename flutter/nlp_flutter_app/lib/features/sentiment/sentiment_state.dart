import 'sentiment_model.dart';

/// Base state for sentiment analysis
abstract class SentimentState {}

/// Initial state
class SentimentInitial extends SentimentState {}

/// Loading state
class SentimentLoading extends SentimentState {}

/// Success state with sentiment result
class SentimentSuccess extends SentimentState {
  final SentimentResult result;

  SentimentSuccess(this.result);
}

/// Error state
class SentimentError extends SentimentState {
  final String message;

  SentimentError(this.message);
}

