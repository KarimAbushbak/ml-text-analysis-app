import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'translation_service.dart';

part 'translation_state.dart';

class TranslationCubit extends Cubit<TranslationState> {
  TranslationCubit() : super(TranslationInitial());
  
  Future<void> translateText({
    required String text,
    String sourceLang = 'en',
    String targetLang = 'ar',
  }) async {
    if (text.trim().isEmpty) {
      emit(TranslationError('Input text cannot be empty'));
      return;
    }
    
    emit(TranslationLoading());
    
    try {
      final result = await TranslationService.translateText(
        text: text,
        sourceLang: sourceLang,
        targetLang: targetLang,
      );
      
      emit(TranslationLoaded(
        originalText: text,
        translatedText: result.translatedText,
        sourceLanguage: sourceLang,
        targetLanguage: targetLang,
      ));
    } catch (e) {
      emit(TranslationError('Failed to translate text: ${e.toString()}'));
    }
  }
  
  void reset() {
    emit(TranslationInitial());
  }
}

