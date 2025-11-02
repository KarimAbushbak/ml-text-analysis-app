import 'package:flutter/material.dart';
import '../../core/widgets/text_input_field.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/result_card.dart';
import '../../core/theme/app_colors.dart';

/// Named Entity Recognition screen
class NERScreen extends StatefulWidget {
  const NERScreen({super.key});

  @override
  State<NERScreen> createState() => _NERScreenState();
}

class _NERScreenState extends State<NERScreen> {
  final _textController = TextEditingController();
  List<Map<String, String>>? _entities;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _recognizeEntities() {
    // TODO: Implement NER logic
    setState(() {
      _entities = [
        {'name': 'John Doe', 'type': 'Person'},
        {'name': 'New York', 'type': 'Location'},
        {'name': 'January 2024', 'type': 'Date'},
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Named Entity Recognition'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextInputField(
              controller: _textController,
              label: 'Your Text',
              hint: 'Enter text to find named entities...',
              maxLines: 8,
              maxLength: 500,
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              text: 'Find Entities',
              gradient: AppColors.purpleGradient,
              onPressed: _recognizeEntities,
            ),
            if (_entities != null) ...[
              const SizedBox(height: 24),
              ResultCard(
                title: 'Found Entities',
                icon: Icons.person_search,
                color: AppColors.primaryPurple,
                child: Column(
                  children: _entities!.map((entity) => _buildEntityChip(entity)).toList(),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEntityChip(Map<String, String> entity) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.primaryPurple.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              _getEntityIcon(entity['type']!),
              color: AppColors.primaryPurple,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                entity['name']!,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryPurple,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                entity['type']!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getEntityIcon(String type) {
    switch (type.toLowerCase()) {
      case 'person':
        return Icons.person;
      case 'location':
        return Icons.location_on;
      case 'date':
        return Icons.calendar_today;
      case 'organization':
        return Icons.business;
      default:
        return Icons.label;
    }
  }
}

