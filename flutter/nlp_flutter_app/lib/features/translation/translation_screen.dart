import 'package:flutter/material.dart';
import '../../core/widgets/text_input_field.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/result_card.dart';
import '../../core/widgets/loading_indicator.dart';
import '../../core/theme/app_colors.dart';
import 'translation_service.dart';

/// Translation screen
class TranslationScreen extends StatefulWidget {
  const TranslationScreen({super.key});

  @override
  State<TranslationScreen> createState() => _TranslationScreenState();
}

class _TranslationScreenState extends State<TranslationScreen> {
  final _sourceController = TextEditingController();
  final _service = TranslationService();
  String _selectedSourceLang = 'English';
  String _selectedTargetLang = 'Spanish';
  String? _translatedText;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _sourceController.dispose();
    super.dispose();
  }

  Future<void> _translate() async {
    if (_sourceController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Please enter some text to translate';
        _translatedText = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _translatedText = null;
    });

    try {
      final result = await _service.translate(
        text: _sourceController.text,
        sourceLang: _selectedSourceLang,
        targetLang: _selectedTargetLang,
      );
      setState(() {
        _translatedText = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
        _translatedText = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Translation'),
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
            _buildLanguageSelector(
              'From',
              _selectedSourceLang,
              (value) => setState(() => _selectedSourceLang = value),
            ),
            const SizedBox(height: 20),
            TextInputField(
              controller: _sourceController,
              label: 'Source Text',
              hint: 'Enter text to translate...',
              maxLines: 6,
              maxLength: 500,
            ),
            const SizedBox(height: 20),
            _buildLanguageSelector(
              'To',
              _selectedTargetLang,
              (value) => setState(() => _selectedTargetLang = value),
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              text: 'Translate',
              gradient: AppColors.blueGradient,
              onPressed: _isLoading ? null : _translate,
            ),
            const SizedBox(height: 24),
            if (_isLoading) ...[
              const Center(child: LoadingIndicator()),
            ] else if (_translatedText != null) ...[
              ResultCard(
                title: 'Translation',
                icon: Icons.translate,
                color: AppColors.primaryBlue,
                content: _translatedText!,
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

  Widget _buildLanguageSelector(String label, String selected, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: selected,
          decoration: InputDecoration(
            filled: true,
            contentPadding: const EdgeInsets.all(16),
          ),
          items: const [
            'English',
            'Spanish',
            'French',
            'German',
            'Italian',
            'Portuguese',
          ].map((lang) => DropdownMenuItem(
            value: lang,
            child: Text(lang),
          )).toList(),
          onChanged: (value) => onChanged(value!),
        ),
      ],
    );
  }
}

