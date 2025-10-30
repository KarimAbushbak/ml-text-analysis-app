import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'sentiment_service.dart';

part 'sentiment_state.dart';

class SentimentCubit extends Cubit<SentimentState> {
  SentimentCubit() : super(SentimentInitial());
  
  Future<void> analyzeSentiment(String text) async {
    if (text.trim().isEmpty) {
      emit(SentimentError('Input text cannot be empty'));
      return;
    }
    
    emit(SentimentLoading());
    
    try {
      final result = await SentimentService.analyzeSentiment(text);
      emit(SentimentLoaded(
        text: text,
        sentiment: result.sentiment,
        confidence: result.confidence,
        allScores: result.allScores,
      ));
    } catch (e) {
      emit(SentimentError('Failed to analyze sentiment: ${e.toString()}'));
    }
  }
  
  void reset() {
    emit(SentimentInitial());
  }
}
