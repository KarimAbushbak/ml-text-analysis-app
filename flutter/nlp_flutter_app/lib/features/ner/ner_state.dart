import 'ner_model.dart';

/// Base state for Named Entity Recognition
abstract class NERState {}

/// Initial state
class NERInitial extends NERState {}

/// Loading state
class NERLoading extends NERState {}

/// Success state with NER results
class NERSuccess extends NERState {
  final List<NerResult> entities;

  NERSuccess(this.entities);
}

/// Error state
class NERError extends NERState {
  final String message;

  NERError(this.message);
}

