import '../../core/models/history_item_model.dart';

/// Base class for history states
abstract class HistoryState {}

/// Initial state when history screen is first created
class HistoryInitial extends HistoryState {}

/// State when history is being loaded
class HistoryLoading extends HistoryState {}

/// State when history is successfully loaded
class HistoryLoaded extends HistoryState {
  final List<HistoryItemModel> items;
  final String? filterType; // null = show all, otherwise filter by feature type

  HistoryLoaded(this.items, {this.filterType});

  /// Check if any filter is applied
  bool get isFiltered => filterType != null;

  /// Get count of items
  int get itemCount => items.length;
}

/// State when history is empty (no items)
class HistoryEmpty extends HistoryState {}

/// State when an error occurs
class HistoryError extends HistoryState {
  final String message;

  HistoryError(this.message);
}

