import 'package:flutter/material.dart';
import '../../core/widgets/text_input_field.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/result_card.dart';
import '../../core/widgets/loading_indicator.dart';
import '../../core/theme/app_colors.dart';
import 'ner_service.dart';

/// Named Entity Recognition screen
class NERScreen extends StatefulWidget {
  const NERScreen({super.key});

  @override
  State<NERScreen> createState() => _NERScreenState();
}

class _NERScreenState extends State<NERScreen> {
  final _textController = TextEditingController();
  final _service = NERService();
  List<Entity>? _entities;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _recognizeEntities() async {
    if (_textController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Please enter some text to analyze';
        _entities = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _entities = null;
    });

    try {
      final result = await _service.recognizeEntities(_textController.text);
      setState(() {
        _entities = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
        _entities = null;
      });
    }
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
              onPressed: _isLoading ? null : _recognizeEntities,
            ),
            const SizedBox(height: 24),
            if (_isLoading) ...[
              const Center(child: LoadingIndicator()),
            ] else if (_entities != null && _entities!.isNotEmpty) ...[
              ResultCard(
                title: 'Found Entities',
                icon: Icons.person_search,
                color: AppColors.primaryPurple,
                child: Column(
                  children: _entities!.map((entity) => _buildEntityChip(entity)).toList(),
                ),
              ),
            ] else if (_entities != null && _entities!.isEmpty) ...[
              ResultCard(
                title: 'No Entities Found',
                icon: Icons.info_outline,
                color: AppColors.primaryBlue,
                content: 'No named entities were found in the provided text.',
              ),
            ] else if (_errorMessage != null) ...[
              ResultCard(
                title: 'Error',
                icon: Icons.error_outline,
                color: AppColors.primaryRed,
                content: _errorMessage!,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEntityChip(Entity entity) {
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
              _getEntityIcon(entity.type),
              color: AppColors.primaryPurple,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                entity.name,
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
                entity.type,
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

