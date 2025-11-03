import 'package:flutter_bloc/flutter_bloc.dart';
import 'paraphrasing_service.dart';
import 'paraphrasing_state.dart';
import 'paraphrasing_model.dart';

/// Cubit for managing paraphrasing state
class ParaphrasingCubit extends Cubit<ParaphrasingState> {
  final _paraphrasingService = ParaphrasingService();
  
  ParaphrasingCubit() : super(ParaphrasingInitial());

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
    } catch (e) {
      emit(ParaphrasingError(e.toString()));
    }
  }
}

