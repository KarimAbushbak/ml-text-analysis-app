part of 'translation_cubit.dart';

sealed class TranslationState {}

final class TranslationInitial extends TranslationState {}

final class TranslationLoading extends TranslationState {}

final class TranslationLoaded extends TranslationState {
  final String originalText;
  final String translatedText;
  final String sourceLanguage;
  final String targetLanguage;
  
  TranslationLoaded({
    required this.originalText,
    required this.translatedText,
    required this.sourceLanguage,
    required this.targetLanguage,
  });
}

final class TranslationError extends TranslationState {
  final String message;
  TranslationError(this.message);
}

