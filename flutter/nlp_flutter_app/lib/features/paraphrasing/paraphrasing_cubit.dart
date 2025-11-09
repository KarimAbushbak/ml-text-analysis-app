import 'package:flutter_bloc/flutter_bloc.dart';
import 'paraphrasing_service.dart';
import 'paraphrasing_state.dart';
import 'paraphrasing_model.dart';
import '../../core/services/history_storage_service.dart';
import '../../core/models/history_item_model.dart';
import '../../core/exceptions/api_exceptions.dart';

/// Cubit for managing paraphrasing state
class ParaphrasingCubit extends Cubit<ParaphrasingState> {
  final _paraphrasingService = ParaphrasingService();
  HistoryStorageService? _historyService;
  
  ParaphrasingCubit() : super(ParaphrasingInitial()) {
    _initHistoryService();
  }

  Future<void> _initHistoryService() async {
    _historyService = await HistoryStorageService.create();
  }

  /// Paraphrases the given text
  Future<void> paraphrase({required String text}) async {
    if (text.trim().isEmpty) {
      emit(ParaphrasingError('Please enter some text'));
      return;
    }

    emit(ParaphrasingLoading());

    try {
      final paraphrasedText = await _paraphrasingService.paraphrase(text);
      final result = ParaphraseResult(
        originalText: text,
        paraphrasedText: paraphrasedText,
      );
      emit(ParaphrasingSuccess(result));

      // Save to history
      if (_historyService != null) {
        await _historyService!.saveHistoryItem(
          HistoryItemModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            featureType: 'paraphrasing',
            timestamp: DateTime.now(),
            inputText: text,
            result: {
              'paraphrased_text': paraphrasedText,
              'original_text': text,
            },
            metaData: null,
          ),
        );
      }
    } on NetworkException catch (e) {
      emit(ParaphrasingError(e.message));
    } on TimeoutException catch (e) {
      emit(ParaphrasingError(e.message));
    } on BadRequestException catch (e) {
      emit(ParaphrasingError(e.message));
    } on ServerException catch (e) {
      emit(ParaphrasingError('Server error: ${e.message}'));
    } on ApiException catch (e) {
      emit(ParaphrasingError(e.message));
    } catch (e) {
      emit(ParaphrasingError('An unexpected error occurred. Please try again.'));
    }
  }
}


