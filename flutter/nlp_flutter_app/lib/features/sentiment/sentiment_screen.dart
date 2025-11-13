import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'sentiment_cubit.dart';
import 'sentiment_state.dart';
import '../../core/widgets/text_input_field.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/result_card.dart';
import '../../core/widgets/loading_indicator.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_dimensions.dart';

/// Sentiment Analysis screen
class SentimentScreen extends StatefulWidget {
  const SentimentScreen({super.key});

  @override
  State<SentimentScreen> createState() => _SentimentScreenState();
}

class _SentimentScreenState extends State<SentimentScreen> {
  final _textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _analyzeSentiment(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<SentimentCubit>().analyzeSentiment(text:_textController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SentimentCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.sentimentAnalysisTitle),
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
                    AppStrings.enterTextToAnalyze,
                    style: TextStyle(
                      fontSize: AppDimensions.fontSize18,
                      fontWeight: AppDimensions.fontWeight600,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacing20),
                  TextInputField(
                    controller: _textController,
                    label: AppStrings.yourText,
                    hint: AppStrings.typeOrPasteText,
                    maxLines: AppDimensions.textInputMaxLines8,
                    maxLength: AppDimensions.textInputMaxLength500,
                  ),
                  const SizedBox(height: AppDimensions.spacing24),
                  Builder(
                    builder: (context) {
                      return PrimaryButton(
                        text: AppStrings.analyzeSentiment,
                        gradient: AppColors.greenGradient,
                        onPressed: () => _analyzeSentiment(context),
                      );
                    }
                  ),
                  const SizedBox(height: AppDimensions.spacing32),
                  BlocBuilder<SentimentCubit, SentimentState>(
                    builder: (context, state) {
                      if (state is SentimentLoading) {
                        return const Center(child: LoadingIndicator());
                      }

                      if (state is SentimentSuccess) {
                        return ResultCard(
                          title: AppStrings.sentimentResult,
                          icon: Icons.sentiment_satisfied,
                          color: AppColors.primaryGreen,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSentimentResult(
                                AppStrings.sentiment,
                                state.result.sentiment,
                                _getSentimentColor(state.result.sentiment),
                              ),
                              const SizedBox(height: AppDimensions.spacing12),
                              _buildSentimentResult(
                                AppStrings.confidence,
                                '${(state.result.confidence * 100)
                                    .toStringAsFixed(1)}%',
                                AppColors.primaryBlue,
                              ),
                            ],
                          ),
                        );
                      }

                      if (state is SentimentError) {
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

  Widget _buildSentimentResult(String label, String value, Color color) {
    return Container(
      padding: AppDimensions.padding16,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: AppDimensions.fontSize16,
              fontWeight: AppDimensions.fontWeight500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: AppDimensions.fontSize16,
              fontWeight: AppDimensions.fontWeightBold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _getSentimentColor(String sentiment) {
    switch (sentiment.toLowerCase()) {
      case 'positive':
        return AppColors.primaryGreen;
      case 'negative':
        return AppColors.primaryRed;
      case 'neutral':
        return AppColors.primaryYellow;
      default:
        return AppColors.primaryBlue;
    }
  }
}

