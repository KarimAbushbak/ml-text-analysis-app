import 'package:flutter_bloc/flutter_bloc.dart';
import 'sentiment_state.dart';
import 'sentiment_model.dart';
import 'sentiment_service.dart';

/// Cubit for managing sentiment analysis state
class SentimentCubit extends Cubit<SentimentState> {
  final SentimentService _service = SentimentService();

  SentimentCubit() : super(SentimentInitial());

  /// Analyzes sentiment of the given text
  Future<void> analyzeSentiment(String text) async {
    if (text.trim().isEmpty) {
      emit(SentimentError('Please enter some text'));
      return;
    }

    emit(SentimentLoading());

    try {
      final result = await _service.analyzeSentiment(text);
      emit(SentimentSuccess(result));
    } catch (e) {
      emit(SentimentError(e.toString().replaceAll('Exception: ', '')));
    }
  }
}

