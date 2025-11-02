import 'package:flutter_bloc/flutter_bloc.dart';
import 'sentiment_state.dart';
import 'sentiment_model.dart';

/// Cubit for managing sentiment analysis state
class SentimentCubit extends Cubit<SentimentState> {
  SentimentCubit() : super(SentimentInitial());

  /// Analyzes sentiment of the given text
  Future<void> analyzeSentiment(String text) async {
    if (text.trim().isEmpty) {
      emit(SentimentError('Please enter some text'));
      return;
    }

    emit(SentimentLoading());

    try {
      // Simulate API call with dummy data
      await Future.delayed(const Duration(seconds: 1));
      
      // TODO: Replace with actual API call
      // final result = await _service.analyzeSentiment(text);
      
      // Dummy data for now
      final result = SentimentResult(
        sentiment: _getDummySentiment(text),
        confidence: 0.85,
      );
      
      emit(SentimentSuccess(result));
    } catch (e) {
      emit(SentimentError(e.toString()));
    }
  }

  /// Get dummy sentiment based on text content
  String _getDummySentiment(String text) {
    final lowerText = text.toLowerCase();
    if (lowerText.contains('love') || lowerText.contains('great') || lowerText.contains('amazing')) {
      return 'positive';
    } else if (lowerText.contains('hate') || lowerText.contains('bad') || lowerText.contains('terrible')) {
      return 'negative';
    }
    return 'neutral';
  }
}

