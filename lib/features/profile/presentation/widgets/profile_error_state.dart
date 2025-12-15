import 'package:flutter/material.dart';
import 'package:to_do_app/core/constants/color_class.dart';
import 'package:to_do_app/core/constants/textstyle_class.dart';

class ProfileErrorState extends StatelessWidget {
  final VoidCallback onRetry;

  const ProfileErrorState({
    super.key,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? ColorClass.darkForeground : ColorClass.kTextColor;
    final errorColor = isDark ? ColorClass.darkDestructive : ColorClass.stateError;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: errorColor,
          ),
          const SizedBox(height: 16),
          Text(
            'Failed to load profile',
            style: TextStyleClass.primaryFont600(18, textColor),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

