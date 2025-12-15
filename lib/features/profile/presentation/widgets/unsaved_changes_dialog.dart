import 'package:flutter/material.dart';
import 'package:to_do_app/core/constants/color_class.dart';
import 'package:to_do_app/core/constants/textstyle_class.dart';

class UnsavedChangesDialog {
  static Future<bool> show(BuildContext context) async {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardColor = isDark ? ColorClass.darkCard : ColorClass.kCardColor;
    final textColor = isDark ? ColorClass.darkForeground : ColorClass.kTextColor;
    final textSecondaryColor = isDark ? ColorClass.darkMutedForeground : ColorClass.kTextSecondary;
    final errorColor = isDark ? ColorClass.darkDestructive : ColorClass.stateError;

    final shouldLeave = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: cardColor,
        title: Text(
          'Unsaved Changes',
          style: TextStyleClass.primaryFont600(18, textColor),
        ),
        content: Text(
          'You have unsaved changes. Are you sure you want to leave?',
          style: TextStyleClass.primaryFont400(14, textSecondaryColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: TextStyleClass.primaryFont500(14, textSecondaryColor),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: errorColor,
              foregroundColor: Colors.white,
            ),
            child: Text(
              'Leave',
              style: TextStyleClass.primaryFont500(14, Colors.white),
            ),
          ),
        ],
      ),
    );

    return shouldLeave ?? false;
  }
}

