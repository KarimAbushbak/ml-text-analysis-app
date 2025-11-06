import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/widgets/text_input_field.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/result_card.dart';
import '../../core/widgets/loading_indicator.dart';
import '../../core/theme/app_colors.dart';
import 'summarization_cubit.dart';
import 'summarization_state.dart';

/// Text Summarization screen
class SummarizationScreen extends StatefulWidget {
  const SummarizationScreen({super.key});

  @override
  State<SummarizationScreen> createState() => _SummarizationScreenState();
}

class _SummarizationScreenState extends State<SummarizationScreen> {
  final _textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _summarize(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<SummarizationCubit>().summarize(
        text: _textController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SummarizationCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Text Summarization'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Enter text to summarize',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                TextInputField(
                  controller: _textController,
                  label: 'Original Text',
                  hint: 'Enter text to summarize (minimum 100 characters)...',
                  maxLines: 10,
                  maxLength: 2000,
                ),
                const SizedBox(height: 24),
                Builder(
                  builder: (context) {
                    return PrimaryButton(
                      text: 'Summarize',
                      gradient: AppColors.orangeGradient,
                      onPressed: () => _summarize(context),
                    );
                  }
                ),
                const SizedBox(height: 32),
                BlocBuilder<SummarizationCubit, SummarizationState>(
                  builder: (context, state) {
                    if (state is SummarizationLoading) {
                      return const Center(child: LoadingIndicator());
                    }

                    if (state is SummarizationSuccess) {
                      return Column(
                        children: [
                          ResultCard(
                            title: 'Summary',
                            icon: Icons.summarize,
                            color: AppColors.primaryOrange,
                            content: state.result.summary,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Original length: ${state.result.originalText.length} characters',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            'Summary length: ${state.result.summary.length} characters',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      );
                    }

                    if (state is SummarizationError) {
                      return ResultCard(
                        title: 'Error',
                        icon: Icons.error_outline,
                        color: AppColors.primaryRed,
                        content: state.message,
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

