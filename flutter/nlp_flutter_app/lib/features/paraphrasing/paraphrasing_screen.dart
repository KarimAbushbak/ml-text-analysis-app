import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/widgets/text_input_field.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/result_card.dart';
import '../../core/widgets/loading_indicator.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_dimensions.dart';
import 'paraphrasing_cubit.dart';
import 'paraphrasing_state.dart';

/// Paraphrasing screen
class ParaphrasingScreen extends StatefulWidget {
  const ParaphrasingScreen({super.key});

  @override
  State<ParaphrasingScreen> createState() => _ParaphrasingScreenState();
}

class _ParaphrasingScreenState extends State<ParaphrasingScreen> {
  final _textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _paraphrase(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<ParaphrasingCubit>().paraphrase(text: _textController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ParaphrasingCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.paraphrasingTitle),
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
                  AppStrings.enterTextToParaphrase,
                  style: TextStyle(
                    fontSize: AppDimensions.fontSize18,
                    fontWeight: AppDimensions.fontWeight600,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacing20),
                TextInputField(
                  controller: _textController,
                  label: AppStrings.originalText,
                  hint: AppStrings.enterTextToParaphraseHint,
                  maxLines: AppDimensions.textInputMaxLines8,
                  maxLength: AppDimensions.textInputMaxLength500,
                ),
                const SizedBox(height: AppDimensions.spacing24),
                Builder(
                  builder: (context) {
                    return PrimaryButton(
                      text: AppStrings.paraphrase,
                      gradient: AppColors.orangeGradient,
                      onPressed: () => _paraphrase(context),
                    );
                  }
                ),
                const SizedBox(height: AppDimensions.spacing32),
                BlocBuilder<ParaphrasingCubit, ParaphrasingState>(
                  builder: (context, state) {
                    if (state is ParaphrasingLoading) {
                      return const Center(child: LoadingIndicator());
                    }

                    if (state is ParaphrasingSuccess) {
                      return ResultCard(
                        title: AppStrings.paraphrasedText,
                        icon: Icons.edit_note,
                        color: AppColors.primaryOrange,
                        content: state.result.paraphrasedText,
                      );
                    }

                    if (state is ParaphrasingError) {
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

