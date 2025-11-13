import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/widgets/text_input_field.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/result_card.dart';
import '../../core/widgets/loading_indicator.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_dimensions.dart';
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
          title: const Text(AppStrings.summarizationTitle),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SingleChildScrollView(
          padding: AppDimensions.padding20,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  AppStrings.enterTextToSummarize,
                  style: TextStyle(
                    fontSize: AppDimensions.fontSize18,
                    fontWeight: AppDimensions.fontWeight600,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacing20),
                TextInputField(
                  controller: _textController,
                  label: AppStrings.originalText,
                  hint: AppStrings.enterTextToSummarizeHint,
                  maxLines: AppDimensions.textInputMaxLines10,
                  maxLength: AppDimensions.textInputMaxLength2000,
                ),
                const SizedBox(height: AppDimensions.spacing24),
                Builder(
                  builder: (context) {
                    return PrimaryButton(
                      text: AppStrings.summarize,
                      gradient: AppColors.orangeGradient,
                      onPressed: () => _summarize(context),
                    );
                  }
                ),
                const SizedBox(height: AppDimensions.spacing32),
                BlocBuilder<SummarizationCubit, SummarizationState>(
                  builder: (context, state) {
                    if (state is SummarizationLoading) {
                      return const Center(child: LoadingIndicator());
                    }

                    if (state is SummarizationSuccess) {
                      return Column(
                        children: [
                          ResultCard(
                            title: AppStrings.summary,
                            icon: Icons.summarize,
                            color: AppColors.primaryOrange,
                            content: state.result.summary,
                          ),
                          const SizedBox(height: AppDimensions.spacing12),
                          Text(
                            '${AppStrings.originalLength}: ${state.result.originalText.length} ${AppStrings.characters}',
                            style: TextStyle(
                              fontSize: AppDimensions.fontSize14,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            '${AppStrings.summaryLength}: ${state.result.summary.length} ${AppStrings.characters}',
                            style: TextStyle(
                              fontSize: AppDimensions.fontSize14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      );
                    }

                    if (state is SummarizationError) {
                      return ResultCard(
                        title: AppStrings.error,
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

