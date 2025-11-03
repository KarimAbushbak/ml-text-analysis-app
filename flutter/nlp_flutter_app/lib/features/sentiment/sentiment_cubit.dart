import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingua_sense/features/sentiment/sentiment_service.dart';
import 'sentiment_state.dart';
import 'sentiment_model.dart';

/// Cubit for managing sentiment analysis state
class SentimentCubit extends Cubit<SentimentState> {
  final _sentimentService = SentimentService();
  SentimentCubit() : super(SentimentInitial());

  /// Analyzes sentiment of the given text
  Future<void> analyzeSentiment({required String text}) async {
    if (text.trim().isEmpty) {
      emit(SentimentError('Please enter some text'));
      return;
    }

    emit(SentimentLoading());

    try {
      final result = await _sentimentService.analyzeSentiment(text: text);
      

      emit(SentimentSuccess(result));
    } catch (e) {
      emit(SentimentError(e.toString()));
    }
  }

  /// Get dummy sentiment based on text content
}

