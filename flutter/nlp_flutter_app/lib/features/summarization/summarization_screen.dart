import 'package:flutter/material.dart';
import '../../core/widgets/text_input_field.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/result_card.dart';
import '../../core/theme/app_colors.dart';

/// Text Summarization screen
class SummarizationScreen extends StatefulWidget {
  const SummarizationScreen({super.key});

  @override
  State<SummarizationScreen> createState() => _SummarizationScreenState();
}

class _SummarizationScreenState extends State<SummarizationScreen> {
  final _textController = TextEditingController();
  String? _summary;
  double _ratio = 0.3;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _summarize() {
    // TODO: Implement summarization logic
    setState(() {
      _summary = 'Summarization feature coming soon!';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text Summarization'),
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
              hint: 'Enter text to summarize...',
              maxLines: 10,
              maxLength: 2000,
            ),
            const SizedBox(height: 16),
            Text(
              'Summary Ratio: ${(_ratio * 100).toInt()}%',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Slider(
              value: _ratio,
              min: 0.1,
              max: 0.5,
              divisions: 4,
              label: '${(_ratio * 100).toInt()}%',
              onChanged: (value) => setState(() => _ratio = value),
            ),
            const SizedBox(height: 8),
            PrimaryButton(
              text: 'Summarize',
              gradient: AppColors.orangeGradient,
              onPressed: _summarize,
            ),
            if (_summary != null) ...[
              const SizedBox(height: 24),
              ResultCard(
                title: 'Summary',
                icon: Icons.summarize,
                color: AppColors.primaryOrange,
                content: _summary!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

