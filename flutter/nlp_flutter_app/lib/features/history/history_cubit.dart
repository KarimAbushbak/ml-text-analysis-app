import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/services/history_storage_service.dart';
import '../../core/models/history_item_model.dart';
import 'history_state.dart';

/// Cubit for managing history state and operations
class HistoryCubit extends Cubit<HistoryState> {
  final HistoryStorageService _storageService;

  HistoryCubit(this._storageService) : super(HistoryInitial());

  /// Load history from storage
  /// Optional filterType parameter to filter by specific feature
  Future<void> loadHistory({String? filterType}) async {
    emit(HistoryLoading());
    try {
      List<HistoryItemModel> items;

      // Load based on filter
      if (filterType != null) {
        items = await _storageService.loadHistoryByType(filterType);
      } else {
        items = await _storageService.loadHistory();
      }

      // Emit appropriate state
      if (items.isEmpty) {
        emit(HistoryEmpty());
      } else {
        emit(HistoryLoaded(items, filterType: filterType));
      }
    } catch (e) {
      emit(HistoryError('Failed to load history: ${e.toString()}'));
    }
  }

  /// Delete a single history item
  Future<void> deleteItem(String id) async {
    try {
      await _storageService.deleteHistoryItem(id);
      
      // Reload history to update UI
      final currentState = state;
      if (currentState is HistoryLoaded) {
        await loadHistory(filterType: currentState.filterType);
      } else {
        await loadHistory();
      }
    } catch (e) {
      emit(HistoryError('Failed to delete item: ${e.toString()}'));
    }
  }

  /// Clear all history
  Future<void> clearAll() async {
    try {
      await _storageService.clearAllHistory();
      emit(HistoryEmpty());
    } catch (e) {
      emit(HistoryError('Failed to clear history: ${e.toString()}'));
    }
  }

  /// Search history by query string
  Future<void> searchHistory(String query) async {
    if (query.isEmpty) {
      // If query is empty, reload all history
      await loadHistory();
      return;
    }

    emit(HistoryLoading());
    try {
      final items = await _storageService.searchHistory(query);

      if (items.isEmpty) {
        emit(HistoryEmpty());
      } else {
        emit(HistoryLoaded(items));
      }
    } catch (e) {
      emit(HistoryError('Search failed: ${e.toString()}'));
    }
  }

  /// Filter history by feature type
  Future<void> filterByType(String? featureType) async {
    await loadHistory(filterType: featureType);
  }
}

