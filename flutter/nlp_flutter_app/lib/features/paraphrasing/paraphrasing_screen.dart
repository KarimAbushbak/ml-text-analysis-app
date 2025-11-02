import 'package:flutter/material.dart';
import '../../core/widgets/text_input_field.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/result_card.dart';
import '../../core/theme/app_colors.dart';

/// Paraphrasing screen
class ParaphrasingScreen extends StatefulWidget {
  const ParaphrasingScreen({super.key});

  @override
  State<ParaphrasingScreen> createState() => _ParaphrasingScreenState();
}

class _ParaphrasingScreenState extends State<ParaphrasingScreen> {
  final _textController = TextEditingController();
  String? _paraphrasedText;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _paraphrase() {
    // TODO: Implement paraphrasing logic
    setState(() {
      _paraphrasedText = 'Paraphrasing feature coming soon!';
    });
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
              onPressed: _paraphrase,
            ),
            if (_paraphrasedText != null) ...[
              const SizedBox(height: 24),
              ResultCard(
                title: 'Paraphrased Text',
                icon: Icons.edit_note,
                color: AppColors.primaryOrange,
                content: _paraphrasedText!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

