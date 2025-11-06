import 'package:flutter_bloc/flutter_bloc.dart';
import 'summarization_service.dart';
import 'summarization_state.dart';
import 'summarization_model.dart';

/// Cubit for managing text summarization state
class SummarizationCubit extends Cubit<SummarizationState> {
  final _summarizationService = SummarizationService();
  
  SummarizationCubit() : super(SummarizationInitial());

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
    } catch (e) {
      emit(SummarizationError(e.toString()));
    }
  }
}

