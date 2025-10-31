import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Result card for displaying analysis results
class ResultCard extends StatelessWidget {
  final String title;
  final String? content;
  final Widget? child;
  final IconData? icon;
  final Color? color;
  final EdgeInsets? padding;

  const ResultCard({
    super.key,
    required this.title,
    this.content,
    this.child,
    this.icon,
    this.color,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: padding ?? const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    color: color ?? AppColors.primaryBlue,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),
            if (content != null || child != null) ...[
              const SizedBox(height: 16),
              if (child != null)
                child!
              else
                Text(
                  content!,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
            ],
          ],
        ),
      ),
    );
  }
}

