import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_app/core/components/background_screen.dart';
import 'package:to_do_app/core/components/textformfield_widget.dart';
import 'package:to_do_app/core/components/primary_button.dart';
import 'package:to_do_app/core/constants/color_class.dart';
import 'package:to_do_app/core/constants/textstyle_class.dart';
import 'package:to_do_app/core/utils/app_utils.dart';
import 'package:to_do_app/features/auth/bloc/auth_bloc.dart';
import 'package:to_do_app/features/auth/bloc/auth_event.dart';
import 'package:to_do_app/features/auth/bloc/auth_state.dart';

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
  
  File? _profilePicture;
  DateTime? _dateOfBirth;
  final ImagePicker _picker = ImagePicker();
  
  String? _usernameError;
  String? _fullNameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  String? _dateOfBirthError;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateEmail);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _fullNameController.dispose();
    _emailController.removeListener(_validateEmail);
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _dateOfBirthController.dispose();
    super.dispose();
  }

  void _validateEmail() {
    final email = _emailController.text.trim();
    debugPrint('Validating email: $email');
    
    if (email.isEmpty) {
      setState(() {
        _emailError = 'Email is required';
      });
    } else if (!AppUtils.isValidEmail(email)) {
      setState(() {
        _emailError = 'Please enter a valid email address';
      });
    } else {
      setState(() {
        _emailError = null;
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    debugPrint('Picking image from: $source');
    
    // Request permission based on source
    Permission permission;
    String permissionMessage;
    
    if (source == ImageSource.camera) {
      permission = Permission.camera;
      permissionMessage = 'Camera permission is required to take photos';
    } else {
      // For gallery, use photos permission (works for both iOS and Android 13+)
      // For older Android versions, image_picker handles storage permission internally
      permission = Permission.photos;
      permissionMessage = 'Photo library permission is required to select images';
    }
    
    // Check current permission status
    PermissionStatus status = await permission.status;
    debugPrint('Permission status: $status');
    
    // Request permission if not granted
    if (!status.isGranted) {
      status = await permission.request();
      debugPrint('Permission request result: $status');
      
      if (!status.isGranted) {
        // Permission denied
        if (status.isPermanentlyDenied) {
          // Show dialog to open app settings
          _showPermissionDeniedDialog(permissionMessage);
        } else {
          AppUtils.showToast(
            context,
            message: permissionMessage,
          );
        }
        return;
      }
    }
    
    // Permission granted, proceed with image picking
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        setState(() {
          _profilePicture = File(image.path);
        });
        debugPrint('Profile picture selected: ${image.path}');
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      AppUtils.showToast(context, message: 'Failed to pick image');
    }
  }

  void _showPermissionDeniedDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Permission Required',
          style: TextStyleClass.primaryFont600(18, ColorClass.kTextColor),
        ),
        content: Text(
          '$message. Please enable it in app settings.',
          style: TextStyleClass.primaryFont400(14, ColorClass.kTextSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyleClass.primaryFont400(
                14,
                ColorClass.kTextSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorClass.kPrimaryColor,
              foregroundColor: Colors.white,
            ),
            child: Text(
              'Open Settings',
              style: TextStyleClass.primaryFont500(14, Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _handleDateOfBirthChange(String dateString) {
    debugPrint('Date of birth changed: $dateString');
    // Parse the date string (format: MM/DD/YYYY)
    try {
      final parts = dateString.split('/');
      if (parts.length == 3) {
        final month = int.parse(parts[0]);
        final day = int.parse(parts[1]);
        final year = int.parse(parts[2]);
        final picked = DateTime(year, month, day);
        
        setState(() {
          _dateOfBirth = picked;
          _dateOfBirthError = null;
        });
        debugPrint('Date of birth parsed: ${picked.toString()}');
      }
    } catch (e) {
      debugPrint('Error parsing date: $e');
    }
  }

  Future<bool> _isUsernameUnique(String username) async {
    debugPrint('Checking if username is unique: $username');
    final prefs = await SharedPreferences.getInstance();
    final savedUsernames = prefs.getStringList('usernames') ?? [];
    final isUnique = !savedUsernames.contains(username.toLowerCase());
    debugPrint('Username unique: $isUnique');
    return isUnique;
  }

  void _validateUsername(String value) {
    if (value.isEmpty) {
      setState(() {
        _usernameError = 'Username is required';
      });
    } else if (value.length < 3) {
      setState(() {
        _usernameError = 'Username must be at least 3 characters';
      });
    } else {
      _isUsernameUnique(value).then((isUnique) {
        if (!isUnique) {
          setState(() {
            _usernameError = 'Username already exists';
          });
        } else {
          setState(() {
            _usernameError = null;
          });
        }
      });
    }
  }

  void _validateFullName(String value) {
    if (value.isEmpty) {
      setState(() {
        _fullNameError = 'Full name is required';
      });
    } else if (value.trim().split(' ').length < 2) {
      setState(() {
        _fullNameError = 'Please enter your full name';
      });
    } else {
      setState(() {
        _fullNameError = null;
      });
    }
  }

  void _validatePassword(String value) {
    if (value.isEmpty) {
      setState(() {
        _passwordError = 'Password is required';
      });
    } else if (value.length < 6) {
      setState(() {
        _passwordError = 'Password must be at least 6 characters';
      });
    } else {
      setState(() {
        _passwordError = null;
      });
    }
  }

  void _validateConfirmPassword(String value) {
    if (value.isEmpty) {
      setState(() {
        _confirmPasswordError = 'Please confirm your password';
      });
    } else if (value != _passwordController.text) {
      setState(() {
        _confirmPasswordError = 'Passwords do not match';
      });
    } else {
      setState(() {
        _confirmPasswordError = null;
      });
    }
  }

  void _validateDateOfBirth() {
    if (_dateOfBirth == null) {
      setState(() {
        _dateOfBirthError = 'Date of birth is required';
      });
    } else {
      setState(() {
        _dateOfBirthError = null;
      });
    }
  }

  void _submitForm() {
    debugPrint('Submitting registration form');
    
    // Validate all fields
    _validateUsername(_usernameController.text);
    _validateFullName(_fullNameController.text);
    _validateEmail();
    _validatePassword(_passwordController.text);
    _validateConfirmPassword(_confirmPasswordController.text);
    _validateDateOfBirth();

    if (_formKey.currentState!.validate() &&
        _usernameError == null &&
        _fullNameError == null &&
        _emailError == null &&
        _passwordError == null &&
        _confirmPasswordError == null &&
        _dateOfBirthError == null) {
      
      // Dispatch register event to AuthBloc
      context.read<AuthBloc>().add(RegisterEvent(
        username: _usernameController.text.trim(),
        fullName: _fullNameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        profilePicture: _profilePicture,
        dateOfBirth: _dateOfBirth,
      ));
    } else {
      debugPrint('Form validation failed');
      AppUtils.showToast(context, message: 'Please fix the errors');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
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
      child: Scaffold(
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
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => SafeArea(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.camera_alt),
                                  title: const Text('Camera'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    _pickImage(ImageSource.camera);
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.photo_library),
                                  title: const Text('Gallery'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    _pickImage(ImageSource.gallery);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: ColorClass.kPrimaryColor.withOpacity(0.1),
                            backgroundImage: _profilePicture != null
                                ? FileImage(_profilePicture!)
                                : null,
                            child: _profilePicture == null
                                ? Icon(
                                    Icons.person,
                                    size: 50,
                                    color: ColorClass.kPrimaryColor,
                                  )
                                : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                              radius: 15,
                              backgroundColor: ColorClass.kPrimaryColor,
                              child: const Icon(
                                Icons.camera_alt,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Username
                  CustomTextField(
                    label: 'Username',
                    prefix: const Icon(Icons.person_outline),
                    controller: _usernameController,
                    type: TextFieldType.text,
                    onChanged: (value) => _validateUsername(value),
                    validator: (value) => _usernameError,
                  ),
                  if (_usernameError != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 16, top: 4),
                      child: Text(
                        _usernameError!,
                        style: TextStyleClass.primaryFont400(
                          12,
                          ColorClass.stateError,
                        ),
                      ),
                    ),
                  const SizedBox(height: 8),
                  
                  // Full Name
                  CustomTextField(
                    label: 'Full Name',
                    prefix: const Icon(Icons.badge_outlined),
                    controller: _fullNameController,
                    type: TextFieldType.text,
                    onChanged: (value) => _validateFullName(value),
                    validator: (value) => _fullNameError,
                  ),
                  if (_fullNameError != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 16, top: 4),
                      child: Text(
                        _fullNameError!,
                        style: TextStyleClass.primaryFont400(
                          12,
                          ColorClass.stateError,
                        ),
                      ),
                    ),
                  const SizedBox(height: 8),
                  
                  // Email
                  CustomTextField(
                    label: 'Email Address',
                    prefix: const Icon(Icons.email_outlined),
                    controller: _emailController,
                    type: TextFieldType.email,
                    validator: (value) => _emailError,
                  ),
                  if (_emailError != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 16, top: 4),
                      child: Text(
                        _emailError!,
                        style: TextStyleClass.primaryFont400(
                          12,
                          ColorClass.stateError,
                        ),
                      ),
                    ),
                  const SizedBox(height: 8),
                  
                  // Password
                  CustomTextField(
                    label: 'Password',
                    prefix: const Icon(Icons.lock_outline),
                    controller: _passwordController,
                    type: TextFieldType.password,
                    onChanged: (value) {
                      _validatePassword(value);
                      if (_confirmPasswordController.text.isNotEmpty) {
                        _validateConfirmPassword(_confirmPasswordController.text);
                      }
                    },
                    validator: (value) => _passwordError,
                  ),
                  if (_passwordError != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 16, top: 4),
                      child: Text(
                        _passwordError!,
                        style: TextStyleClass.primaryFont400(
                          12,
                          ColorClass.stateError,
                        ),
                      ),
                    ),
                  const SizedBox(height: 8),
                  
                  // Confirm Password
                  CustomTextField(
                    label: 'Confirm Password',
                    prefix: const Icon(Icons.lock_outline),
                    controller: _confirmPasswordController,
                    type: TextFieldType.password,
                    onChanged: (value) => _validateConfirmPassword(value),
                    validator: (value) => _confirmPasswordError,
                  ),
                  if (_confirmPasswordError != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 16, top: 4),
                      child: Text(
                        _confirmPasswordError!,
                        style: TextStyleClass.primaryFont400(
                          12,
                          ColorClass.stateError,
                        ),
                      ),
                    ),
                  const SizedBox(height: 8),
                  
                  // Date of Birth
                  CustomTextField(
                    label: 'Date of Birth',
                    prefix: const Icon(Icons.calendar_today_outlined),
                    controller: _dateOfBirthController,
                    type: TextFieldType.date,
                    onChanged: _handleDateOfBirthChange,
                  ),
                  if (_dateOfBirthError != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 16, top: 4),
                      child: Text(
                        _dateOfBirthError!,
                        style: TextStyleClass.primaryFont400(
                          12,
                          ColorClass.stateError,
                        ),
                      ),
                    ),
                  const SizedBox(height: 24),
                  
                  // Submit Button
                  PrimaryButton(
                    text: 'REGISTER',
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
      ),
    );
  }
}

