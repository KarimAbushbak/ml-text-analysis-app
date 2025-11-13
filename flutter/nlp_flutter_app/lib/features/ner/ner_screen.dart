import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/widgets/text_input_field.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/result_card.dart';
import '../../core/widgets/loading_indicator.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_dimensions.dart';
import 'ner_cubit.dart';
import 'ner_state.dart';
import 'ner_model.dart';

/// Named Entity Recognition screen
class NERScreen extends StatefulWidget {
  const NERScreen({super.key});

  @override
  State<NERScreen> createState() => _NERScreenState();
}

class _NERScreenState extends State<NERScreen> {
  final _textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _recognizeEntities(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<NERCubit>().recognizeEntities(text: _textController.text.toUpperCase());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NERCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.nerTitle),
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
                  AppStrings.enterTextToExtractEntities,
                  style: TextStyle(
                    fontSize: AppDimensions.fontSize18,
                    fontWeight: AppDimensions.fontWeight600,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacing20),
                TextInputField(
                  controller: _textController,
                  label: AppStrings.yourText,
                  hint: AppStrings.enterTextToFindEntities,
                  maxLines: AppDimensions.textInputMaxLines8,
                  maxLength: AppDimensions.textInputMaxLength500,
                ),
                const SizedBox(height: AppDimensions.spacing24),
                Builder(
                  builder: (context) {
                    return PrimaryButton(
                      text: AppStrings.findEntities,
                      gradient: AppColors.purpleGradient,
                      onPressed: () => _recognizeEntities(context),
                    );
                  }
                ),
                const SizedBox(height: AppDimensions.spacing32),
                BlocBuilder<NERCubit, NERState>(
                  builder: (context, state) {
                    if (state is NERLoading) {
                      return const Center(child: LoadingIndicator());
                    }

                    if (state is NERSuccess) {
                      if (state.entities.isEmpty) {
                        return ResultCard(
                          title: AppStrings.noEntitiesFound,
                          icon: Icons.info_outline,
                          color: AppColors.primaryBlue,
                          content: AppStrings.noEntitiesDetected,
                        );
                      }

                      return ResultCard(
                        title: '${AppStrings.foundEntities} (${state.entities.length})',
                        icon: Icons.person_search,
                        color: AppColors.primaryPurple,
                        child: Column(
                          children: state.entities.map((entity) => _buildEntityChip(entity)).toList(),
                        ),
                      );
                    }

                    if (state is NERError) {
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

  Widget _buildEntityChip(NerResult entity) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppDimensions.spacing4),
      child: Container(
        padding: AppDimensions.padding12,
        decoration: BoxDecoration(
          color: AppColors.primaryPurple.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius8),
        ),
        child: Row(
          children: [
            Icon(
              _getEntityIcon(entity.label),
              color: AppColors.primaryPurple,
              size: AppDimensions.iconSize20,
            ),
            const SizedBox(width: AppDimensions.spacing12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entity.text,
                    style: TextStyle(fontWeight: AppDimensions.fontWeight600),
                  ),
                  Text(
                    '${AppStrings.confidence}: ${(entity.score * 100).toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: AppDimensions.fontSize12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacing8, vertical: AppDimensions.spacing4),
              decoration: BoxDecoration(
                color: AppColors.primaryPurple,
                borderRadius: BorderRadius.circular(AppDimensions.borderRadius12),
              ),
              child: Text(
                _getEntityLabel(entity.label),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: AppDimensions.fontSize12,
                  fontWeight: AppDimensions.fontWeight600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getEntityLabel(String label) {
    // Convert common NER label abbreviations to full names
    switch (label.toUpperCase()) {
      case 'PER':
      case 'PERSON':
        return AppStrings.entityPerson;
      case 'LOC':
      case 'LOCATION':
        return AppStrings.entityLocation;
      case 'ORG':
      case 'ORGANIZATION':
        return AppStrings.entityOrganization;
      case 'MISC':
      case 'MISCELLANEOUS':
        return AppStrings.entityMisc;
      case 'DATE':
        return AppStrings.entityDate;
      case 'TIME':
        return AppStrings.entityTime;
      case 'MONEY':
        return AppStrings.entityMoney;
      case 'PERCENT':
        return AppStrings.entityPercent;
      default:
        return label;
    }
  }

  IconData _getEntityIcon(String type) {
    switch (type.toUpperCase()) {
      case 'PER':
      case 'PERSON':
        return Icons.person;
      case 'LOC':
      case 'LOCATION':
        return Icons.location_on;
      case 'DATE':
      case 'TIME':
        return Icons.calendar_today;
      case 'ORG':
      case 'ORGANIZATION':
        return Icons.business;
      case 'MONEY':
      case 'PERCENT':
        return Icons.attach_money;
      default:
        return Icons.label;
    }
  }
}

