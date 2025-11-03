import 'paraphrasing_model.dart';

/// Base state for paraphrasing
abstract class ParaphrasingState {}

/// Initial state
class ParaphrasingInitial extends ParaphrasingState {}

/// Loading state
class ParaphrasingLoading extends ParaphrasingState {}

/// Success state with paraphrased result
class ParaphrasingSuccess extends ParaphrasingState {
  final ParaphraseResult result;

  ParaphrasingSuccess(this.result);
}

/// Error state
class ParaphrasingError extends ParaphrasingState {
  final String message;

  ParaphrasingError(this.message);
}

