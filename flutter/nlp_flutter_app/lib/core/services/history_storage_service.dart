import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/history_item_model.dart';

class HistoryStorageService {
  static const String _historyKey = 'analysis_history';
  static const int _maxItems = 100; // Limit storage

  final SharedPreferences _prefs;

  HistoryStorageService(this._prefs);

  static Future<HistoryStorageService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return HistoryStorageService(prefs);
  }

  /// Load all history items from storage
  /// Returns list sorted by timestamp (newest first)
  Future<List<HistoryItemModel>> loadHistory() async {
    try {
      // Get JSON string from shared_preferences
      final String? historyJson = _prefs.getString(_historyKey);

      // If no history exists, return empty list
      if (historyJson == null || historyJson.isEmpty) {
        return [];
      }

      // Parse JSON array
      final List<dynamic> historyList = jsonDecode(historyJson);

      // Convert each to HistoryItemModel
      final items = historyList
          .map((json) => HistoryItemModel.fromJson(json as Map<String, dynamic>))
          .toList();

      // Sort by timestamp (newest first)
      items.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      return items;
    } catch (e) {
      debugPrint('Error loading history: $e');
      return []; // Return empty list on error
    }
  }

  /// Save a new history item
  /// Automatically maintains max limit of items
  Future<void> saveHistoryItem(HistoryItemModel item) async {
    try {
      // Load existing history
      final List<HistoryItemModel> items = await loadHistory();

      // Add new item at the beginning
      items.insert(0, item);

      // Keep only last 100 items (remove oldest if exceeding limit)
      if (items.length > _maxItems) {
        items.removeRange(_maxItems, items.length);
      }

      // Convert all to JSON
      final List<Map<String, dynamic>> jsonList =
          items.map((item) => item.toJson()).toList();

      final String jsonString = jsonEncode(jsonList);

      // Save to shared_preferences
      await _prefs.setString(_historyKey, jsonString);
    } catch (e) {
      debugPrint('Error saving history item: $e');
      // Don't throw - we don't want to break the main feature if history fails
    }
  }

  /// Delete a specific item by ID
  Future<void> deleteHistoryItem(String id) async {
    try {
      // Load all items
      final List<HistoryItemModel> items = await loadHistory();

      // Remove item with matching id
      items.removeWhere((item) => item.id == id);

      // Convert to JSON and save back
      final List<Map<String, dynamic>> jsonList =
          items.map((item) => item.toJson()).toList();

      final String jsonString = jsonEncode(jsonList);

      await _prefs.setString(_historyKey, jsonString);
    } catch (e) {
      debugPrint('Error deleting history item: $e');
      rethrow; // Re-throw so UI can show error
    }
  }

  /// Clear all history
  Future<void> clearAllHistory() async {
    try {
      await _prefs.remove(_historyKey);
    } catch (e) {
      debugPrint('Error clearing history: $e');
      rethrow;
    }
  }

  /// Get history count
  Future<int> getHistoryCount() async {
    final items = await loadHistory();
    return items.length;
  }

  /// Get history filtered by feature type
  Future<List<HistoryItemModel>> loadHistoryByType(String featureType) async {
    final items = await loadHistory();
    return items.where((item) => item.featureType == featureType).toList();
  }

  /// Search history by input text
  Future<List<HistoryItemModel>> searchHistory(String query) async {
    final items = await loadHistory();
    final lowerQuery = query.toLowerCase();
    return items
        .where((item) => item.inputText.toLowerCase().contains(lowerQuery))
        .toList();
  }
}

