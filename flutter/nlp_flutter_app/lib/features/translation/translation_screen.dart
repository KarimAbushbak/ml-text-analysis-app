import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/widgets/text_input_field.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/result_card.dart';
import '../../core/widgets/loading_indicator.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/language_constants.dart';
import 'translation_cubit.dart';

/// Translation screen
class TranslationScreen extends StatefulWidget {
  const TranslationScreen({super.key});

  @override
  State<TranslationScreen> createState() => _TranslationScreenState();
}

class _TranslationScreenState extends State<TranslationScreen> {
  final _textController = TextEditingController();
  String _selectedSourceLang = 'en';
  String _selectedTargetLang = 'ar';

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _translate(BuildContext context) {
    context.read<TranslationCubit>().translateText(
      text: _textController.text,
      sourceLang: _selectedSourceLang,
      targetLang: _selectedTargetLang,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TranslationCubit(),
      child: Scaffold(
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
                controller: _textController,
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
              Builder(
                builder: (context) => PrimaryButton(
                  text: 'Translate',
                  gradient: AppColors.blueGradient,
                  onPressed: () => _translate(context),
                ),
              ),
              const SizedBox(height: 32),
              BlocBuilder<TranslationCubit, TranslationState>(
                builder: (context, state) {
                  if (state is TranslationLoading) {
                    return const Center(child: LoadingIndicator());
                  }

                  if (state is TranslationSuccess) {
                    return Column(
                      children: [
                        ResultCard(
                          title: 'Translation',
                          icon: Icons.translate,
                          color: AppColors.primaryBlue,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${LanguageConstants.getLanguageName(state.result.sourceLang)} → ${LanguageConstants.getLanguageName(state.result.targetLang)}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.primaryBlue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Divider(),
                              const SizedBox(height: 8),
                              Text(
                                state.result.translatedText,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }

                  if (state is TranslationFailure) {
                    return ResultCard(
                      title: 'Error',
                      icon: Icons.error_outline,
                      color: AppColors.primaryRed,
                      content: state.errorMessage,
                    );
                  }

                  return const SizedBox.shrink();

                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageSelector(String label, String selectedCode, Function(String) onChanged) {
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
          value: selectedCode,
          decoration: const InputDecoration(
            filled: true,
            contentPadding: EdgeInsets.all(16),
          ),
          items: LanguageConstants.languageNames.entries.map((entry) {
            return DropdownMenuItem(
              value: entry.key, // Language code (en, ar, etc.)
              child: Text(entry.value), // Display name (English, Arabic, etc.)
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              onChanged(value);
            }
          },
        ),
      ],
    );
  }
}
