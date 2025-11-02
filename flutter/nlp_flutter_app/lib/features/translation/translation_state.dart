part of 'translation_cubit.dart';

@immutable
sealed class TranslationState {}

final class TranslationInitial extends TranslationState {}
final class TranslationLoading extends TranslationState {}
final class TranslationSuccess extends TranslationState {
  final TranslationResult result;
  TranslationSuccess(this.result);
}
final class TranslationFailure extends TranslationState {
  final String errorMessage;
  TranslationFailure(this.errorMessage);

}
