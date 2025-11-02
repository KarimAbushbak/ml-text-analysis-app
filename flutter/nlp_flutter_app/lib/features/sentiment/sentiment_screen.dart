import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'sentiment_cubit.dart';
import 'sentiment_state.dart';
import '../../core/widgets/text_input_field.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/result_card.dart';
import '../../core/widgets/loading_indicator.dart';
import '../../core/theme/app_colors.dart';

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
      context.read<SentimentCubit>().analyzeSentiment(_textController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SentimentCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sentiment Analysis'),
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
                    'Enter the text you want to analyze',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextInputField(
                    controller: _textController,
                    label: 'Your Text',
                    hint: 'Type or paste your text here...',
                    maxLines: 8,
                    maxLength: 500,
                  ),
                  const SizedBox(height: 24),
                  Builder(
                    builder: (context) {
                      return PrimaryButton(
                        text: 'Analyze Sentiment',
                        gradient: AppColors.greenGradient,
                        onPressed: () => _analyzeSentiment(context),
                      );
                    }
                  ),
                  const SizedBox(height: 32),
                  BlocBuilder<SentimentCubit, SentimentState>(
                    builder: (context, state) {
                      if (state is SentimentLoading) {
                        return const Center(child: LoadingIndicator());
                      }

                      if (state is SentimentSuccess) {
                        return ResultCard(
                          title: 'Sentiment Result',
                          icon: Icons.sentiment_satisfied,
                          color: AppColors.primaryGreen,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSentimentResult(
                                'Sentiment',
                                state.result.sentiment,
                                _getSentimentColor(state.result.sentiment),
                              ),
                              const SizedBox(height: 12),
                              _buildSentimentResult(
                                'Confidence',
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

  Widget _buildSentimentResult(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
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

