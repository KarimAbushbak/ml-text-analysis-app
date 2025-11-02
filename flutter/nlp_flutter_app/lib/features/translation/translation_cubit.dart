import 'package:bloc/bloc.dart';
import 'package:lingua_sense/features/translation/translation_model.dart';
import 'package:lingua_sense/features/translation/translation_service.dart';
import 'package:meta/meta.dart';

part 'translation_state.dart';

class TranslationCubit extends Cubit<TranslationState> {
  final _translationService = TranslationService();

  TranslationCubit() : super(TranslationInitial());
  Future<void> translateText({
    required String text,
    required String sourceLang,
    required String targetLang,
  }) async {
    emit(TranslationLoading());
    try {
      final result = await _translationService.translate(
        text: text,
        sourceLang: sourceLang,
        targetLang: targetLang,
      );
      emit(TranslationSuccess(result));
    } catch (e) {
      emit(TranslationFailure(e.toString()));
    }
  }
}
