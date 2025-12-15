import 'package:flutter/material.dart';
import 'package:to_do_app/core/constants/color_class.dart';
import 'package:to_do_app/core/constants/textstyle_class.dart';

class EmptyState extends StatelessWidget {
  final bool hasTriedApiAndFailed;
  final VoidCallback? onRefresh;
  
  const EmptyState({
    super.key,
    this.hasTriedApiAndFailed = false,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? ColorClass.darkForeground : ColorClass.kTextColor;
    final textSecondaryColor = isDark ? ColorClass.darkMutedForeground : ColorClass.kTextSecondary;
    final primaryColor = isDark ? ColorClass.darkPrimary : ColorClass.kPrimaryColor;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark 
                  ? ColorClass.darkMuted.withOpacity(0.2)
                  : ColorClass.kDecorativeGreen.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              hasTriedApiAndFailed 
                  ? Icons.error_outline_rounded
                  : Icons.check_circle_outline_rounded,
              size: 64,
              color: hasTriedApiAndFailed
                  ? (isDark ? ColorClass.darkDestructive : ColorClass.stateError)
                  : primaryColor.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            hasTriedApiAndFailed ? 'No data found' : 'No todos yet!',
            style: TextStyleClass.primaryFont600(20, textColor),
          ),
          const SizedBox(height: 8),
          Text(
            hasTriedApiAndFailed 
                ? 'Unable to load data. Please check your connection and try again.'
                : 'Pull down to refresh or tap the refresh button',
            style: TextStyleClass.primaryFont400(14, textSecondaryColor),
            textAlign: TextAlign.center,
          ),
          // Always show refresh button when onRefresh is provided
          if (onRefresh != null) ...[
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRefresh,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(
                hasTriedApiAndFailed ? 'Retry' : 'Refresh',
                style: TextStyleClass.primaryFont500(16, Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

