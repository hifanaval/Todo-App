import 'package:flutter/material.dart';
import 'package:to_do_app/core/constants/color_class.dart';
import 'package:to_do_app/core/constants/textstyle_class.dart';

class ErrorMessageWidget extends StatelessWidget {
  final String? errorMessage;

  const ErrorMessageWidget({
    super.key,
    required this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (errorMessage == null) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final errorColor = isDark ? ColorClass.darkDestructive : ColorClass.stateError;

    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 4),
      child: Text(
        errorMessage!,
        style: TextStyleClass.primaryFont400(12, errorColor),
      ),
    );
  }
}

