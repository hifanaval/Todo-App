import 'package:flutter/material.dart';
import 'package:to_do_app/core/constants/color_class.dart';
import 'package:to_do_app/core/constants/textstyle_class.dart';

class DateOfBirthField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onTap;

  const DateOfBirthField({
    super.key,
    required this.controller,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? ColorClass.darkForeground : ColorClass.kTextColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date of Birth',
          style: TextStyleClass.primaryFont500(14, textColor),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: true,
          decoration: const InputDecoration(
            hintText: 'Select date of birth',
            prefixIcon: Icon(Icons.calendar_today_outlined),
          ),
          onTap: onTap,
        ),
      ],
    );
  }
}

