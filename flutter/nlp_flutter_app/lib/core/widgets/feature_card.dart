import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Feature card with icon and label for home dashboard
class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final Gradient? gradient;
  final VoidCallback onTap;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: gradient,
          color: gradient == null ? (isDark ? AppColors.cardDark : AppColors.cardLight) : null,
          boxShadow: [
            if (isDark)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              )
            else
              BoxShadow(
                color: (gradient?.colors.first ?? AppColors.primaryBlue).withValues(alpha: 0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: gradient == null
                      ? (gradient?.colors.first ?? color ?? AppColors.primaryBlue).withValues(alpha: 0.1)
                      : Colors.white.withValues(alpha: 0.2),
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: gradient == null
                      ? (color ?? AppColors.primaryBlue)
                      : Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                label,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: gradient == null
                      ? null
                      : Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

