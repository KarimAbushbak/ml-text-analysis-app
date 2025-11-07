import 'package:flutter/material.dart';

class HistoryItemModel {
  final String id;
  final String featureType;
  final DateTime timestamp;
  final String inputText;
  final Map<String, dynamic> result;
  final Map<String, dynamic>? metaData;

  HistoryItemModel({
    required this.id,
    required this.featureType,
    required this.timestamp,
    required this.inputText,
    required this.result,
    this.metaData,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'featureType': featureType,
      'timestamp': timestamp.toIso8601String(),
      'inputText': inputText,
      'result': result,
      'metaData': metaData,
    };
  }

  factory HistoryItemModel.fromJson(Map<String, dynamic> json) {
    return HistoryItemModel(
      id: json['id'] as String,
      featureType: json['featureType'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      inputText: json['inputText'] as String,
      result: json['result'] as Map<String, dynamic>,
      metaData: json['metaData'] as Map<String, dynamic>?,
    );
  }

  String get displayTitle {
    switch (featureType) {
      case 'translation':
        return 'Translation';
      case 'sentiment':
        return 'Sentiment Analysis';
      case 'paraphrasing':
        return 'Paraphrasing';
      case 'ner':
        return 'Named Entity Recognition';
      case 'summarization':
        return 'Summarization';
      default:
        return 'Unknown';
    }
  }

  // Get truncated input text for preview (max 100 characters)
  String get inputPreview {
    if (inputText.length <= 100) {
      return inputText;
    }
    return '${inputText.substring(0, 97)}...';
  }

  IconData get displayIcon {
    switch (featureType) {
      case 'translation':
        return Icons.translate;
      case 'sentiment':
        return Icons.sentiment_satisfied;
      case 'paraphrasing':
        return Icons.edit_note;
      case 'ner':
        return Icons.person_search;
      case 'summarization':
        return Icons.summarize;
      default:
        return Icons.help_outline;
    }
  }

  // Get time ago string
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks week${weeks > 1 ? 's' : ''} ago';
    } else {
      final months = (difference.inDays / 30).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    }
  }

  // Format timestamp as readable date
  String get formattedDate {
    return '${timestamp.day}/${timestamp.month}/${timestamp.year} ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
  }
}
