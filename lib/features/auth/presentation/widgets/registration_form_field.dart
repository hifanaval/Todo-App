import 'package:flutter/material.dart';
import 'package:to_do_app/core/components/textformfield_widget.dart';
import 'error_message_widget.dart';

export 'package:to_do_app/core/components/textformfield_widget.dart' show TextFieldType;

class RegistrationFormField extends StatelessWidget {
  final String label;
  final Icon prefix;
  final TextEditingController controller;
  final TextFieldType type;
  final String? errorMessage;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;

  const RegistrationFormField({
    super.key,
    required this.label,
    required this.prefix,
    required this.controller,
    required this.type,
    this.errorMessage,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          label: label,
          prefix: prefix,
          controller: controller,
          type: type,
          onChanged: onChanged,
          validator: validator ?? (value) => errorMessage,
        ),
        ErrorMessageWidget(errorMessage: errorMessage),
        const SizedBox(height: 8),
      ],
    );
  }
}

