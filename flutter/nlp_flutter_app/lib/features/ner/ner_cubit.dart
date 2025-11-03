import 'package:flutter_bloc/flutter_bloc.dart';
import 'ner_service.dart';
import 'ner_state.dart';

/// Cubit for managing Named Entity Recognition state
class NERCubit extends Cubit<NERState> {
  final _nerService = NERService();
  
  NERCubit() : super(NERInitial());

  /// Recognizes named entities in the given text
  Future<void> recognizeEntities({required String text}) async {
    if (text.trim().isEmpty) {
      emit(NERError('Please enter some text'));
      return;
    }

    emit(NERLoading());

    try {
      final entities = await _nerService.recognizeEntities(text: text);
      emit(NERSuccess(entities));
    } catch (e) {
      emit(NERError(e.toString()));
    }
  }
}

