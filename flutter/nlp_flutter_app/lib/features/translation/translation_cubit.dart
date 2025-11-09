import 'package:bloc/bloc.dart';
import 'package:lingua_sense/features/translation/translation_model.dart';
import 'package:lingua_sense/features/translation/translation_service.dart';
import 'package:meta/meta.dart';
import '../../core/services/history_storage_service.dart';
import '../../core/models/history_item_model.dart';
import '../../core/exceptions/api_exceptions.dart';

part 'translation_state.dart';

class TranslationCubit extends Cubit<TranslationState> {
  final _translationService = TranslationService();
  HistoryStorageService? _historyService;

  TranslationCubit() : super(TranslationInitial()) {
    _initHistoryService();
  }

  Future<void> _initHistoryService() async {
    _historyService = await HistoryStorageService.create();
  }
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

      // Save to history
      if (_historyService != null) {
        await _historyService!.saveHistoryItem(
          HistoryItemModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            featureType: 'translation',
            timestamp: DateTime.now(),
            inputText: text,
            result: {
              'translated_text': result.translatedText,
              'source_lang': result.sourceLang,
              'target_lang': result.targetLang,
            },
            metaData: {
              'source_lang': sourceLang,
              'target_lang': targetLang,
            },
          ),
        );
      }
    } on NetworkException catch (e) {
      emit(TranslationFailure(e.message));
    } on TimeoutException catch (e) {
      emit(TranslationFailure(e.message));
    } on BadRequestException catch (e) {
      emit(TranslationFailure(e.message));
    } on ServerException catch (e) {
      emit(TranslationFailure('Server error: ${e.message}'));
    } on ApiException catch (e) {
      emit(TranslationFailure(e.message));
    } catch (e) {
      emit(TranslationFailure('An unexpected error occurred. Please try again.'));
    }
  }
}
