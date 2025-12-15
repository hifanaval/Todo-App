import 'package:flutter/material.dart';
import 'package:to_do_app/core/constants/color_class.dart';
import 'package:to_do_app/core/constants/textstyle_class.dart';

class ProfileCompletenessIndicator extends StatelessWidget {
  final int completeness;

  const ProfileCompletenessIndicator({
    super.key,
    required this.completeness,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardColor = isDark ? ColorClass.darkCard : ColorClass.kCardColor;
    final textColor = isDark ? ColorClass.darkForeground : ColorClass.kTextColor;
    final primaryColor = isDark ? ColorClass.darkPrimary : ColorClass.kPrimaryColor;
    final backgroundColor = isDark ? ColorClass.darkMuted : ColorClass.neutral200;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Profile Completeness',
                style: TextStyleClass.primaryFont600(16, textColor),
              ),
              Text(
                '$completeness%',
                style: TextStyleClass.primaryFont600(16, primaryColor),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: completeness / 100,
              minHeight: 8,
              backgroundColor: backgroundColor,
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}

