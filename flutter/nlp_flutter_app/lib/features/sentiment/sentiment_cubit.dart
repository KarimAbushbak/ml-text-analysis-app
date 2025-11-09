import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingua_sense/features/sentiment/sentiment_service.dart';
import 'sentiment_state.dart';
import '../../core/services/history_storage_service.dart';
import '../../core/models/history_item_model.dart';
import '../../core/exceptions/api_exceptions.dart';

/// Cubit for managing sentiment analysis state
class SentimentCubit extends Cubit<SentimentState> {
  final _sentimentService = SentimentService();
  HistoryStorageService? _historyService;

  SentimentCubit() : super(SentimentInitial()) {
    _initHistoryService();
  }

  Future<void> _initHistoryService() async {
    _historyService = await HistoryStorageService.create();
  }

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

      // Save to history
      if (_historyService != null) {
        await _historyService!.saveHistoryItem(
          HistoryItemModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            featureType: 'sentiment',
            timestamp: DateTime.now(),
            inputText: text,
            result: {
              'sentiment': result.sentiment,
              'confidence': result.confidence,
            },
            metaData: null,
          ),
        );
      }
    } on NetworkException catch (e) {
      emit(SentimentError(e.message));
    } on TimeoutException catch (e) {
      emit(SentimentError(e.message));
    } on BadRequestException catch (e) {
      emit(SentimentError(e.message));
    } on ServerException catch (e) {
      emit(SentimentError('Server error: ${e.message}'));
    } on ApiException catch (e) {
      emit(SentimentError(e.message));
    } catch (e) {
      emit(SentimentError('An unexpected error occurred. Please try again.'));
    }
  }

  /// Get dummy sentiment based on text content
}

