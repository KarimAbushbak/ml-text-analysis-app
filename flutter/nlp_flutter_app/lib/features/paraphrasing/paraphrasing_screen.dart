import 'package:flutter/material.dart';
import '../../core/widgets/text_input_field.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/result_card.dart';
import '../../core/widgets/loading_indicator.dart';
import '../../core/theme/app_colors.dart';
import 'paraphrasing_service.dart';

/// Paraphrasing screen
class ParaphrasingScreen extends StatefulWidget {
  const ParaphrasingScreen({super.key});

  @override
  State<ParaphrasingScreen> createState() => _ParaphrasingScreenState();
}

class _ParaphrasingScreenState extends State<ParaphrasingScreen> {
  final _textController = TextEditingController();
  final _service = ParaphrasingService();
  String? _paraphrasedText;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _paraphrase() async {
    if (_textController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Please enter some text to paraphrase';
        _paraphrasedText = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _paraphrasedText = null;
    });

    try {
      final result = await _service.paraphrase(_textController.text);
      setState(() {
        _paraphrasedText = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
        _paraphrasedText = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paraphrasing'),
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
              label: 'Original Text',
              hint: 'Enter text to paraphrase...',
              maxLines: 8,
              maxLength: 500,
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              text: 'Paraphrase',
              gradient: AppColors.orangeGradient,
              onPressed: _isLoading ? null : _paraphrase,
            ),
            const SizedBox(height: 24),
            if (_isLoading) ...[
              const Center(child: LoadingIndicator()),
            ] else if (_paraphrasedText != null) ...[
              ResultCard(
                title: 'Paraphrased Text',
                icon: Icons.edit_note,
                color: AppColors.primaryOrange,
                content: _paraphrasedText!,
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
}

