import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/widgets/feature_card.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/api_constants.dart';

/// Home dashboard with grid of feature cards
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final features = [
      {
        'icon': Icons.sentiment_satisfied,
        'label': AppStrings.sentimentAnalysis,
        'gradient': AppColors.greenGradient,
        'route': ApiConstants.routeSentiment,
      },
      {
        'icon': Icons.translate,
        'label': AppStrings.translation,
        'gradient': AppColors.blueGradient,
        'route': ApiConstants.routeTranslation,
      },
      {
        'icon': Icons.edit_note,
        'label': AppStrings.paraphrasing,
        'gradient': AppColors.orangeGradient,
        'route': ApiConstants.routeParaphrasing,
      },
      {
        'icon': Icons.person_search,
        'label': AppStrings.namedEntityRecognition,
        'gradient': AppColors.purpleGradient,
        'route': ApiConstants.routeNER,
      },
      {
        'icon': Icons.summarize,
        'label': AppStrings.summarization,
        'gradient': AppColors.orangeGradient,
        'route': ApiConstants.routeSummarization,
      },
      {
        'icon': Icons.history,
        'label': AppStrings.history,
        'gradient': AppColors.blueGradient,
        'route': ApiConstants.routeHistory,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push(ApiConstants.routeSettings),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: AppDimensions.padding20,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.welcome,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: AppDimensions.fontWeightBold,
                  ),
            ),
            const SizedBox(height: AppDimensions.spacing8),
            Text(
              AppStrings.chooseFeature,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
            ),
            const SizedBox(height: AppDimensions.spacing32),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: AppDimensions.gridCrossAxisCount,
                crossAxisSpacing: AppDimensions.gridCrossAxisSpacing,
                mainAxisSpacing: AppDimensions.gridMainAxisSpacing,
                childAspectRatio: AppDimensions.gridChildAspectRatio,
              ),
              itemCount: features.length,
              itemBuilder: (context, index) {
                final feature = features[index];
                return FeatureCard(
                  icon: feature['icon'] as IconData,
                  label: feature['label'] as String,
                  gradient: feature['gradient'] as Gradient,
                  onTap: () => context.push(feature['route'] as String),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

