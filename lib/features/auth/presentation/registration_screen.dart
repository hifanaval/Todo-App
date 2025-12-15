import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:to_do_app/core/components/background_screen.dart';
import 'package:to_do_app/core/components/primary_button.dart';
import 'package:to_do_app/core/components/textformfield_widget.dart';
import 'package:to_do_app/core/constants/color_class.dart';
import 'package:to_do_app/core/constants/textstyle_class.dart';
import 'package:to_do_app/core/utils/app_utils.dart';
import 'package:to_do_app/core/utils/image_picker_utils.dart';
import 'package:to_do_app/features/auth/bloc/auth_bloc.dart';
import 'package:to_do_app/features/auth/bloc/auth_event.dart';
import 'package:to_do_app/features/auth/bloc/auth_state.dart';
import 'widgets/registration_profile_picker.dart';
import 'widgets/registration_form_field.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _dateOfBirthController = TextEditingController();

  @override
  void initState() {
    super.initState();
    debugPrint('RegistrationScreen: Initializing registration form');
    // Initialize registration form state in BLoC
    context.read<AuthBloc>().add(const InitializeRegistrationFormEvent());
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _dateOfBirthController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    debugPrint('RegistrationScreen: Picking image from: $source');
    final imagePath = await ImagePickerUtils.pickImage(
      source: source,
      context: context,
    );

    if (imagePath != null && mounted) {
      context.read<AuthBloc>().add(UpdateProfilePictureEvent(imagePath));
      debugPrint('RegistrationScreen: Profile picture selected: $imagePath');
    }
  }

  void _handleDateOfBirthChange(String dateString) {
    debugPrint('RegistrationScreen: Date of birth changed: $dateString');
    // Parse the date string (format: MM/DD/YYYY)
    try {
      final parts = dateString.split('/');
      if (parts.length == 3) {
        final month = int.parse(parts[0]);
        final day = int.parse(parts[1]);
        final year = int.parse(parts[2]);
        final picked = DateTime(year, month, day);
        
        context.read<AuthBloc>().add(UpdateDateOfBirthEvent(
          dateString: dateString,
          dateTime: picked,
        ));
        debugPrint('RegistrationScreen: Date of birth parsed: ${picked.toString()}');
      }
    } catch (e) {
      debugPrint('RegistrationScreen: Error parsing date: $e');
    }
  }

  void _submitForm() {
    debugPrint('RegistrationScreen: Submitting registration form');
    
    final currentState = context.read<AuthBloc>().state;
    if (currentState is! RegistrationFormState) {
      debugPrint('RegistrationScreen: Form not initialized, initializing...');
      context.read<AuthBloc>().add(const InitializeRegistrationFormEvent());
      AppUtils.showToast(context, message: 'Form not initialized');
      return;
    }
    
    // Validate all fields first
    context.read<AuthBloc>().add(const ValidateRegistrationFormEvent());
    
    // Wait for validation to complete (async validation for username)
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      
      final state = context.read<AuthBloc>().state;
      if (state is RegistrationFormState && state.isFormValid) {
        debugPrint('RegistrationScreen: Form is valid, submitting...');
        // Dispatch register event to AuthBloc (will read from form state)
        context.read<AuthBloc>().add(const RegisterEvent(
          username: '', // Will be read from form state
          fullName: '',
          email: '',
          password: '',
        ));
      } else {
        debugPrint('RegistrationScreen: Form validation failed');
        if (state is RegistrationFormState) {
          final errors = [
            if (state.usernameError != null) state.usernameError,
            if (state.fullNameError != null) state.fullNameError,
            if (state.emailError != null) state.emailError,
            if (state.passwordError != null) state.passwordError,
            if (state.confirmPasswordError != null) state.confirmPasswordError,
            if (state.dateOfBirthError != null) state.dateOfBirthError,
          ].whereType<String>().join(', ');
          AppUtils.showToast(context, message: errors.isNotEmpty ? errors : 'Please fix the errors');
        } else {
          AppUtils.showToast(context, message: 'Please fix the errors');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        debugPrint('RegistrationScreen: Received state: ${state.runtimeType}');
        if (state is RegistrationSuccess) {
          debugPrint('RegistrationScreen: Registration successful');
          AppUtils.showToast(context, message: 'Registration successful');
          Navigator.pushReplacementNamed(context, AppUtils.loginRoute);
        } else if (state is AuthError) {
          debugPrint('RegistrationScreen: Registration error: ${state.message}');
          AppUtils.showToast(context, message: state.message);
        }
      },
      builder: (context, state) {
        final formState = state is RegistrationFormState ? state : const RegistrationFormState();
        
        return Scaffold(
          body: BackgroundPattern(
            child: SafeArea(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        'Create Account',
                        style: TextStyleClass.primaryFont700(
                          32,
                          ColorClass.kTextColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      
                      // Profile Picture
                      RegistrationProfilePicker(
                        profilePicture: formState.profilePicturePath != null
                            ? File(formState.profilePicturePath!)
                            : null,
                        onTap: () {
                          ImagePickerUtils.showImageSourceBottomSheet(
                            context: context,
                            onCameraSelected: () => _pickImage(ImageSource.camera),
                            onGallerySelected: () => _pickImage(ImageSource.gallery),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      
                      // Username
                      RegistrationFormField(
                        label: 'Username',
                        prefix: const Icon(Icons.person_outline),
                        controller: _usernameController,
                        type: TextFieldType.text,
                        errorMessage: formState.usernameError,
                        onChanged: (value) {
                          context.read<AuthBloc>().add(UpdateUsernameEvent(value));
                        },
                      ),
                      
                      // Full Name
                      RegistrationFormField(
                        label: 'Full Name',
                        prefix: const Icon(Icons.badge_outlined),
                        controller: _fullNameController,
                        type: TextFieldType.text,
                        errorMessage: formState.fullNameError,
                        onChanged: (value) {
                          context.read<AuthBloc>().add(UpdateFullNameEvent(value));
                        },
                      ),
                      
                      // Email
                      RegistrationFormField(
                        label: 'Email Address',
                        prefix: const Icon(Icons.email_outlined),
                        controller: _emailController,
                        type: TextFieldType.email,
                        errorMessage: formState.emailError,
                        onChanged: (value) {
                          context.read<AuthBloc>().add(UpdateEmailEvent(value));
                        },
                      ),
                      
                      // Password
                      RegistrationFormField(
                        label: 'Password',
                        prefix: const Icon(Icons.lock_outline),
                        controller: _passwordController,
                        type: TextFieldType.password,
                        errorMessage: formState.passwordError,
                        onChanged: (value) {
                          context.read<AuthBloc>().add(UpdatePasswordEvent(value));
                        },
                      ),
                      
                      // Confirm Password
                      RegistrationFormField(
                        label: 'Confirm Password',
                        prefix: const Icon(Icons.lock_outline),
                        controller: _confirmPasswordController,
                        type: TextFieldType.password,
                        errorMessage: formState.confirmPasswordError,
                        onChanged: (value) {
                          context.read<AuthBloc>().add(UpdateConfirmPasswordEvent(value));
                        },
                      ),
                      
                      // Date of Birth
                      RegistrationFormField(
                        label: 'Date of Birth',
                        prefix: const Icon(Icons.calendar_today_outlined),
                        controller: _dateOfBirthController,
                        type: TextFieldType.date,
                        errorMessage: formState.dateOfBirthError,
                        onChanged: _handleDateOfBirthChange,
                      ),
                      const SizedBox(height: 24),
                      
                      // Submit Button
                      PrimaryButton(
                        text: 'REGISTER',
                        isLoading: state is AuthLoading,
                        onPressed: _submitForm,
                      ),
                      const SizedBox(height: 16),
                      
                      // Login Link
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, AppUtils.loginRoute);
                        },
                        child: Text.rich(
                          TextSpan(
                            text: 'Already have an account? ',
                            style: TextStyleClass.primaryFont400(
                              14,
                              ColorClass.kTextSecondary,
                            ),
                            children: [
                              TextSpan(
                                text: 'Log In',
                                style: TextStyleClass.primaryFont600(
                                  14,
                                  ColorClass.kPrimaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

}

