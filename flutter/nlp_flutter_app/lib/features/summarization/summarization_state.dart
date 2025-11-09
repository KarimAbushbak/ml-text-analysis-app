import 'summarization_model.dart';

/// Base state for text summarization
abstract class SummarizationState {}

/// Initial state
class SummarizationInitial extends SummarizationState {}

/// Loading state
class SummarizationLoading extends SummarizationState {}

/// Success state with summarization result
class SummarizationSuccess extends SummarizationState {
  final SummarizationResult result;

  SummarizationSuccess(this.result);
}

/// Error state
class SummarizationError extends SummarizationState {
  final String message;

  SummarizationError(this.message);
}



