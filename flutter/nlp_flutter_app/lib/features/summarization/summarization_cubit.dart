import 'package:flutter_bloc/flutter_bloc.dart';
import 'summarization_service.dart';
import 'summarization_state.dart';
import 'summarization_model.dart';
import '../../core/services/history_storage_service.dart';
import '../../core/models/history_item_model.dart';
import '../../core/exceptions/api_exceptions.dart';

/// Cubit for managing text summarization state
class SummarizationCubit extends Cubit<SummarizationState> {
  final _summarizationService = SummarizationService();
  HistoryStorageService? _historyService;
  
  SummarizationCubit() : super(SummarizationInitial()) {
    _initHistoryService();
  }

  Future<void> _initHistoryService() async {
    _historyService = await HistoryStorageService.create();
  }

  /// Summarizes the given text
  Future<void> summarize({
    required String text,
  }) async {
    if (text.trim().isEmpty) {
      emit(SummarizationError('Please enter some text'));
      return;
    }

    if (text.trim().length < 100) {
      emit(SummarizationError('Text is too short to summarize. Please enter at least 100 characters.'));
      return;
    }

    emit(SummarizationLoading());

    try {
      final summary = await _summarizationService.summarize(text: text);
      
      final result = SummarizationResult(
        originalText: text,
        summary: summary,
      );
      
      emit(SummarizationSuccess(result));

      // Save to history
      if (_historyService != null) {
        await _historyService!.saveHistoryItem(
          HistoryItemModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            featureType: 'summarization',
            timestamp: DateTime.now(),
            inputText: text,
            result: {
              'summary': summary,
              'original_length': text.length,
              'summary_length': summary.length,
            },
            metaData: null,
          ),
        );
      }
    } on NetworkException catch (e) {
      emit(SummarizationError(e.message));
    } on TimeoutException catch (e) {
      emit(SummarizationError(e.message));
    } on BadRequestException catch (e) {
      emit(SummarizationError(e.message));
    } on ServerException catch (e) {
      emit(SummarizationError('Server error: ${e.message}'));
    } on ApiException catch (e) {
      emit(SummarizationError(e.message));
    } catch (e) {
      emit(SummarizationError('An unexpected error occurred. Please try again.'));
    }
  }
}

