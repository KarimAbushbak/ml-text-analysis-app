import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/models/history_item_model.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/result_card.dart';

/// Detail screen showing full information about a history item
class HistoryDetailScreen extends StatelessWidget {
  final HistoryItemModel item;

  const HistoryDetailScreen({super.key, required this.item});

  Color _getFeatureColor() {
    switch (item.featureType) {
      case 'translation':
        return AppColors.primaryBlue;
      case 'sentiment':
        return AppColors.primaryGreen;
      case 'paraphrasing':
        return AppColors.primaryOrange;
      case 'ner':
        return AppColors.primaryPurple;
      case 'summarization':
        return AppColors.primaryOrange;
      default:
        return AppColors.primaryBlue;
    }
  }

  String _getResultText() {
    switch (item.featureType) {
      case 'translation':
        return item.result['translated_text'] ?? 'N/A';
      case 'sentiment':
        final sentiment = item.result['sentiment'] ?? 'N/A';
        final confidence = item.result['confidence'] ?? 0.0;
        return '$sentiment (${(confidence * 100).toStringAsFixed(1)}%)';
      case 'paraphrasing':
        return item.result['paraphrased_text'] ?? 'N/A';
      case 'ner':
        final entities = item.result['entities'] as List<dynamic>? ?? [];
        if (entities.isEmpty) return 'No entities found';
        return entities.map((e) => '${e['text']} (${e['label']})').join('\n');
      case 'summarization':
        return item.result['summary'] ?? 'N/A';
      default:
        return item.result.toString();
    }
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.displayTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            tooltip: 'Copy result',
            onPressed: () => _copyToClipboard(context, _getResultText()),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Feature badge and time
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _getFeatureColor().withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    item.displayIcon,
                    color: _getFeatureColor(),
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.displayTitle,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.formattedDate,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Input text
            ResultCard(
              title: 'Input',
              icon: Icons.input,
              color: Colors.grey[700]!,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectableText(
                    item.inputText,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: () => _copyToClipboard(context, item.inputText),
                        icon: const Icon(Icons.copy, size: 16),
                        label: const Text('Copy'),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Result/Output
            ResultCard(
              title: 'Result',
              icon: Icons.output,
              color: _getFeatureColor(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectableText(
                    _getResultText(),
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: () => _copyToClipboard(context, _getResultText()),
                        icon: const Icon(Icons.copy, size: 16),
                        label: const Text('Copy'),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Metadata if available
            if (item.metaData != null && item.metaData!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.grey[600], size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Additional Info',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ...item.metaData!.entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${entry.key}: ',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  entry.value.toString(),
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

