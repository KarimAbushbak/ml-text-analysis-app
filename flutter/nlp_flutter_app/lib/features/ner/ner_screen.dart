import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/widgets/text_input_field.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/result_card.dart';
import '../../core/widgets/loading_indicator.dart';
import '../../core/theme/app_colors.dart';
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
          title: const Text('Named Entity Recognition'),
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
                  'Enter text to extract named entities',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                TextInputField(
                  controller: _textController,
                  label: 'Your Text',
                  hint: 'Enter text to find named entities...',
                  maxLines: 8,
                  maxLength: 500,
                ),
                const SizedBox(height: 24),
                Builder(
                  builder: (context) {
                    return PrimaryButton(
                      text: 'Find Entities',
                      gradient: AppColors.purpleGradient,
                      onPressed: () => _recognizeEntities(context),
                    );
                  }
                ),
                const SizedBox(height: 32),
                BlocBuilder<NERCubit, NERState>(
                  builder: (context, state) {
                    if (state is NERLoading) {
                      return const Center(child: LoadingIndicator());
                    }

                    if (state is NERSuccess) {
                      if (state.entities.isEmpty) {
                        return ResultCard(
                          title: 'No Entities Found',
                          icon: Icons.info_outline,
                          color: AppColors.primaryBlue,
                          content: 'No named entities were detected in the text.',
                        );
                      }

                      return ResultCard(
                        title: 'Found Entities (${state.entities.length})',
                        icon: Icons.person_search,
                        color: AppColors.primaryPurple,
                        child: Column(
                          children: state.entities.map((entity) => _buildEntityChip(entity)).toList(),
                        ),
                      );
                    }

                    if (state is NERError) {
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

  Widget _buildEntityChip(NerResult entity) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.primaryPurple.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              _getEntityIcon(entity.label),
              color: AppColors.primaryPurple,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entity.text,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'Confidence: ${(entity.score * 100).toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryPurple,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _getEntityLabel(entity.label),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
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
        return 'Person';
      case 'LOC':
      case 'LOCATION':
        return 'Location';
      case 'ORG':
      case 'ORGANIZATION':
        return 'Organization';
      case 'MISC':
      case 'MISCELLANEOUS':
        return 'Misc';
      case 'DATE':
        return 'Date';
      case 'TIME':
        return 'Time';
      case 'MONEY':
        return 'Money';
      case 'PERCENT':
        return 'Percent';
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

