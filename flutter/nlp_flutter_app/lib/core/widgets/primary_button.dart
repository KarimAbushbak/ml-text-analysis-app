import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../constants/app_dimensions.dart';

/// Primary button with gradient and rounded corners
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Gradient? gradient;
  final double? width;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.gradient,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: AppDimensions.buttonHeight,
      decoration: BoxDecoration(
        gradient: gradient ?? AppColors.blueGradient,
        borderRadius: BorderRadius.circular(AppDimensions.buttonBorderRadius),
        boxShadow: [
          BoxShadow(
            color: (gradient?.colors.first ?? AppColors.primaryBlue).withValues(alpha: 0.3),
            offset: AppDimensions.shadowOffset,
            blurRadius: AppDimensions.shadowBlurRadius,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppDimensions.buttonBorderRadius),
          onTap: isLoading ? null : onPressed,
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: AppDimensions.loadingIndicatorSize,
                    height: AppDimensions.loadingIndicatorSize,
                    child: const CircularProgressIndicator(
                      strokeWidth: AppDimensions.loadingIndicatorStrokeWidth,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    text,
                    style: TextStyle(
                      fontSize: AppDimensions.fontSize16,
                      fontWeight: AppDimensions.fontWeight600,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

