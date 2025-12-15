import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:to_do_app/core/constants/color_class.dart';
import 'package:to_do_app/core/constants/textstyle_class.dart';

enum TextFieldType {
  text,
  email,
  password,
  number,
  textarea,
  date,
  search
}

enum TextFieldSize { full, half, third, quarter }

enum TextFieldVariant { default_, ghost, outline, filled }

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? initialValue;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final int? maxLines;
  final int? minLines;
  final bool obscureText;
  final bool readOnly;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final TextStyle? style;
  final TextAlign? textAlign;
  final InputDecoration? decoration;
  final TextFieldType type;
  final TextFieldSize size;
  final TextFieldVariant variant;
  final String? defaultValue;
  final FocusNode? focusNode;

  // Optional prefix, suffix, label and hint text parameters.
  final Widget? prefix;
  final Widget? suffix;
  final String? label;
  final String? hintText;

  // Optional custom styles for label and hint.
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;

  // Optional input formatters.
  final List<TextInputFormatter>? inputFormatters;

  // Shadcn specific parameters
  final bool hasBorder;
  final double? borderRadius;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;
  final Color? backgroundColor;
  final EdgeInsets? contentPadding;
  final bool showClearButton;
  final VoidCallback? onClear;
  final bool isDisabled;
  final bool isLoading;
  final String? helperText;
  final String? errorText;
  final bool showCharacterCount;
  final bool autoFocus;

  // Validation parameters
  final String? customValidationMessage;
  final int? minLength;
  final int? maxLength;
  final bool required;

  // Add new textarea specific properties
  final bool isResizable;
  final double textareaHeight;
  final bool showResizeHandle;
  final bool autoExpand;
  final int? maxCharacters;
  final bool showWordCount;

  // Add new style parameters for dark theme
  final bool useDarkTheme;
  final Color? textColor;
  final Color? placeholderColor;
  final double? iconSize;

  const CustomTextField({
    super.key,
    this.controller,
    this.initialValue,
    this.validator,
    this.keyboardType,
    this.maxLines = 1,
    this.minLines = 1,
    this.obscureText = false,
    this.readOnly = false,
    this.onChanged,
    this.onTap,
    this.style,
    this.textAlign,
    this.decoration,
    this.prefix,
    this.suffix,
    this.label,
    this.hintText,
    this.labelStyle,
    this.hintStyle,
    this.inputFormatters,
    this.type = TextFieldType.text,
    this.size = TextFieldSize.full,
    this.variant = TextFieldVariant.default_,
    this.defaultValue,
    this.focusNode,
    this.hasBorder = true,
    this.borderRadius = 90,
    this.borderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.backgroundColor,
    this.contentPadding,
    this.showClearButton = false,
    this.onClear,
    this.customValidationMessage,
    this.minLength,
    this.maxLength,
    this.required = false,
    this.isDisabled = false,
    this.isLoading = false,
    this.helperText,
    this.errorText,
    this.showCharacterCount = false,
    this.autoFocus = false,
    this.isResizable = true,
    this.textareaHeight = 200,
    this.showResizeHandle = true,
    this.autoExpand = false,
    this.maxCharacters,
    this.showWordCount = false,
    // New parameters
    this.useDarkTheme = false,
    this.textColor,
    this.placeholderColor,
    this.iconSize = 24,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _showPassword = false;

  String? _validateField(String? value) {
    if (widget.required && (value == null || value.isEmpty)) {
      return '${widget.label ?? 'This field'} is required';
    }

    if (value == null || value.isEmpty) return null;

    if (widget.minLength != null && value.length < widget.minLength!) {
      return '${widget.label ?? 'This field'} must be at least $widget.minLength characters';
    }

    if (widget.maxLength != null && value.length > widget.maxLength!) {
      return '${widget.label ?? 'This field'} must be at most $widget.maxLength characters';
    }

    switch (widget.type) {
      case TextFieldType.email:
        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
        if (!emailRegex.hasMatch(value)) {
          return widget.customValidationMessage ??
              'Please enter a valid email address';
        }
        break;

      case TextFieldType.password:
        if (value.length < 8) {
          return widget.customValidationMessage ??
              'Password must be at least 8 characters';
        }
        if (!value.contains(RegExp(r'[A-Z]'))) {
          return widget.customValidationMessage ??
              'Password must contain at least one uppercase letter';
        }
        if (!value.contains(RegExp(r'[a-z]'))) {
          return widget.customValidationMessage ??
              'Password must contain at least one lowercase letter';
        }
        if (!value.contains(RegExp(r'[0-9]'))) {
          return widget.customValidationMessage ??
              'Password must contain at least one number';
        }
        break;

      case TextFieldType.number:
        if (!RegExp(r'^\d+$').hasMatch(value)) {
          return widget.customValidationMessage ?? 'Please enter only numbers';
        }
        break;

      case TextFieldType.date:
        final dateRegex = RegExp(r'^\d{2}/\d{2}/\d{4}$');
        if (!dateRegex.hasMatch(value)) {
          return widget.customValidationMessage ??
              'Please enter a valid date (MM/DD/YYYY)';
        }
        // Additional date validation
        final parts = value.split('/');
        final month = int.parse(parts[0]);
        final day = int.parse(parts[1]);
        final year = int.parse(parts[2]);

        if (month < 1 || month > 12) {
          return widget.customValidationMessage ?? 'Invalid month';
        }
        if (day < 1 || day > 31) {
          return widget.customValidationMessage ?? 'Invalid day';
        }
        if (year < 1900 || year > DateTime.now().year) {
          return widget.customValidationMessage ?? 'Invalid year';
        }
        break;

      default:
        break;
    }

    return widget.validator?.call(value);
  }

  TextInputType _getKeyboardType() {
    switch (widget.type) {
      case TextFieldType.email:
        return TextInputType.emailAddress;
      case TextFieldType.number:
        return TextInputType.number;
      case TextFieldType.textarea:
        return TextInputType.multiline;
      case TextFieldType.search:
        return TextInputType.text;
      default:
        return widget.keyboardType ?? TextInputType.text;
    }
  }

  List<TextInputFormatter> _getInputFormatters() {
    debugPrint('Getting input formatters for type: ${widget.type}');
    List<TextInputFormatter> formatters = [];

    if (widget.type == TextFieldType.date) {
      // Date formatter using FilteringTextInputFormatter instead of MaskTextInputFormatter
      formatters.add(FilteringTextInputFormatter.allow(RegExp(r'[0-9/]')));
    } else if (widget.type == TextFieldType.number) {
      formatters.add(FilteringTextInputFormatter.digitsOnly);
    }

    if (widget.inputFormatters != null) {
      formatters.addAll(widget.inputFormatters!);
    }

    return formatters;
  }

  InputDecoration _buildDecoration(BuildContext context) {
    final defaultBorderRadius = widget.borderRadius ?? 90.0;
    final defaultBorderColor = widget.borderColor ??  _getBorderColor();
    final defaultFocusedBorderColor = widget.focusedBorderColor ?? (ColorClass.primary.withAlpha((0.5 * 255).toInt()));
    
    return widget.decoration ??
        InputDecoration(
          alignLabelWithHint: true,
          labelText: widget.label,
          labelStyle: widget.labelStyle ??
              TextStyleClass.primaryFont500(14, widget.placeholderColor ?? ColorClass.neutral300),
          hintText: widget.hintText,
          hintStyle: widget.hintStyle ??
              TextStyleClass.primaryFont400(16, widget.placeholderColor ?? ColorClass.neutral500),
          prefixIcon: widget.prefix != null
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    height: widget.iconSize,
                    width: widget.iconSize,
                    child: Center(child: widget.prefix),
                  ),
                )
              : null,
          suffixIcon: _buildSuffixIcon(),
          filled: true,
          fillColor: widget.backgroundColor ?? _getBackgroundColor(),
          contentPadding: widget.contentPadding ?? 
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: _buildBorder(defaultBorderRadius, defaultBorderColor),
          enabledBorder: _buildBorder(defaultBorderRadius, defaultBorderColor),
          focusedBorder: _buildBorder(defaultBorderRadius, defaultFocusedBorderColor),
          errorBorder: _buildBorder(defaultBorderRadius, widget.errorBorderColor ?? ColorClass.stateError),
          helperText: widget.helperText,
          errorText: widget.errorText,
          counter: _buildCounter(),
        );
  }

  Widget? _buildCounter() {
    if (!widget.showCharacterCount && !widget.showWordCount) return null;

    String counterText = '';
    if (widget.showCharacterCount && widget.maxLength != null) {
      counterText =
          '${widget.controller?.text.length ?? 0}/$widget.maxLength characters';
    } else if (widget.showWordCount) {
      final wordCount = widget.controller?.text
              .split(RegExp(r'\s+'))
              .where((word) => word.isNotEmpty)
              .length ??
          0;
      counterText = '$wordCount words';
    }

    return Text(
      counterText,
      style: TextStyleClass.primaryFont400(12, ColorClass.neutral300),
    );
  }

  Color _getBorderColor() {
    if (widget.isDisabled) return ColorClass.neutral200;
    if (widget.errorText != null) return ColorClass.stateError;
    return ColorClass.white.withAlpha((0.8 * 255).toInt());
  }

  Color _getBackgroundColor() {
    if (widget.isDisabled) return ColorClass.neutral100;
    // Default glassmorphism background for new design
    return ColorClass.white.withAlpha((0.6 * 255).toInt());
  }

  InputBorder _buildBorder(double radius, Color color) {
    if (!widget.hasBorder) return InputBorder.none;

    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: BorderSide(
        color: color,
        width: 1,
      ),
    );
  }

  Widget? _buildSuffixIcon() {
    if (widget.isLoading) {
      return SizedBox(
        height: widget.iconSize,
        width: widget.iconSize,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(ColorClass.primary),
        ),
      );
    }

    if (widget.type == TextFieldType.password) {
      return GestureDetector(
        child: Icon(
          _showPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          size: widget.iconSize,
          color: widget.placeholderColor ?? ColorClass.neutral300,
        ),
        onTap: () {
          setState(() {
            _showPassword = !_showPassword;
          });
        },
      );
    }

    if (widget.suffix != null) {
      return SizedBox(
        height: widget.iconSize,
        width: widget.iconSize,
        child: Center(child: widget.suffix),
      );
    }

    if (widget.showClearButton && widget.controller?.text.isNotEmpty == true) {
      return GestureDetector(
        onTap: widget.onClear,
        child: Icon(
          Icons.clear,
          size: widget.iconSize,
          color: widget.placeholderColor ?? ColorClass.neutral300,
        ),
      );
    }

    return null;
  }

  double _getWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    switch (widget.size) {
      case TextFieldSize.full:
        return screenWidth;
      case TextFieldSize.half:
        return screenWidth / 2;
      case TextFieldSize.third:
        return screenWidth / 3;
      case TextFieldSize.quarter:
        return screenWidth / 4;
    }
  }

  Future<void> _showDatePicker(BuildContext context) async {
    if (widget.readOnly || widget.isDisabled) return;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.year,
      helpText: 'Select Date',
      cancelText: 'Cancel',
      confirmText: 'Select',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: ColorClass.kPrimaryColor,
              onPrimary: Colors.white,
              surface: ColorClass.kBackgroundColor,
              onSurface: ColorClass.kTextColor,
            ),
            dialogBackgroundColor: ColorClass.kBackgroundColor,
          ),
          child: child!,
        );
      },
    );

    if (picked != null && widget.controller != null) {
      final formattedDate =
          "${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}/${picked.year}";
      widget.controller?.text = formattedDate;
      widget.onChanged?.call(formattedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultTextStyle = widget.style ??
        TextStyleClass.primaryFont400(
          16,
          widget.textColor ?? ColorClass.neutral700,
        );

    if (widget.type == TextFieldType.textarea) {
      return SizedBox(
        width: _getWidth(context),
        child: Material(
          color: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: widget.controller,
                initialValue: widget.initialValue ?? widget.defaultValue,
                validator: _validateField,
                keyboardType: TextInputType.multiline,
                minLines: widget.autoExpand ? null : (widget.minLines ?? 7),
                maxLines: widget.autoExpand ? null : (widget.maxLines ?? 7),
                obscureText: false,
                readOnly: widget.readOnly || widget.isDisabled,
                onChanged: widget.onChanged,
                onTap: widget.onTap,
                style: defaultTextStyle,
                textAlign: widget.textAlign ?? TextAlign.start,
                inputFormatters: _getInputFormatters(),
                decoration: _buildDecoration(context),
                autofocus: widget.autoFocus,
                focusNode: widget.focusNode,
                cursorColor: widget.useDarkTheme ? ColorClass.primary : null,
              ),
              if (widget.showResizeHandle && widget.isResizable)
                SizedBox(
                  height: 20,
                  child: Center(
                    child: Icon(
                      Icons.drag_handle,
                      size: 16,
                      color: widget.placeholderColor ?? ColorClass.neutral300,
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    }

    if (widget.type == TextFieldType.date) {
      return SizedBox(
        width: _getWidth(context),
        child: Material(
          color: Colors.transparent,
          child: TextFormField(
            controller: widget.controller,
            initialValue: widget.initialValue ?? widget.defaultValue,
            validator: _validateField,
            readOnly: true,
            onTap: () => _showDatePicker(context),
            decoration: _buildDecoration(context).copyWith(
              suffixIcon: Icon(Icons.calendar_today,
                  size: 20, color: ColorClass.neutral300),
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: _getWidth(context),
      child: Material(
        color: Colors.transparent,
        child: TextFormField(
          controller: widget.controller,
          initialValue: widget.initialValue ?? widget.defaultValue,
          validator: _validateField,
          keyboardType: _getKeyboardType(),
          minLines: widget.minLines ?? 1,
          maxLines: widget.maxLines ?? 1,
          obscureText: widget.type == TextFieldType.password ? !_showPassword : widget.obscureText,
          readOnly: widget.readOnly || widget.isDisabled,
          onChanged: widget.onChanged,
          onTap: widget.onTap,
          style: defaultTextStyle,
          textAlign: widget.textAlign ?? TextAlign.start,
          inputFormatters: _getInputFormatters(),
          decoration: _buildDecoration(context),
          autofocus: widget.autoFocus,
          focusNode: widget.focusNode,
          cursorColor: widget.useDarkTheme ? ColorClass.primary : null,
        ),
      ),
    );
  }
}
