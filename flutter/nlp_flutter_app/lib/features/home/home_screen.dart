import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/widgets/feature_card.dart';
import '../../core/theme/app_colors.dart';

/// Home dashboard with grid of feature cards
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final features = [
      {
        'icon': Icons.sentiment_satisfied,
        'label': 'Sentiment\nAnalysis',
        'gradient': AppColors.greenGradient,
        'route': '/sentiment',
      },
      {
        'icon': Icons.translate,
        'label': 'Translation',
        'gradient': AppColors.blueGradient,
        'route': '/translation',
      },
      {
        'icon': Icons.edit_note,
        'label': 'Paraphrasing',
        'gradient': AppColors.orangeGradient,
        'route': '/paraphrasing',
      },
      {
        'icon': Icons.person_search,
        'label': 'Named Entity\nRecognition',
        'gradient': AppColors.purpleGradient,
        'route': '/ner',
      },
      {
        'icon': Icons.summarize,
        'label': 'Summarization',
        'gradient': AppColors.orangeGradient,
        'route': '/summarization',
      },
      {
        'icon': Icons.history,
        'label': 'History',
        'gradient': AppColors.blueGradient,
        'route': '/history',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('LinguaSense'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome! 👋',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Choose a feature to get started',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
            ),
            const SizedBox(height: 32),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
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

