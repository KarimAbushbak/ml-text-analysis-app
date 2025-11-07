import 'package:flutter_bloc/flutter_bloc.dart';
import 'ner_service.dart';
import 'ner_state.dart';
import '../../core/services/history_storage_service.dart';
import '../../core/models/history_item_model.dart';

/// Cubit for managing Named Entity Recognition state
class NERCubit extends Cubit<NERState> {
  final _nerService = NERService();
  HistoryStorageService? _historyService;
  
  NERCubit() : super(NERInitial()) {
    _initHistoryService();
  }

  Future<void> _initHistoryService() async {
    _historyService = await HistoryStorageService.create();
  }

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

      // Save to history
      if (_historyService != null) {
        await _historyService!.saveHistoryItem(
          HistoryItemModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            featureType: 'ner',
            timestamp: DateTime.now(),
            inputText: text,
            result: {
              'entities': entities.map((e) => e.toJson()).toList(),
              'entity_count': entities.length,
            },
            metaData: null,
          ),
        );
      }
    } catch (e) {
      emit(NERError(e.toString()));
    }
  }
}


