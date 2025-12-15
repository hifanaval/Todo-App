import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:to_do_app/core/components/background_screen.dart';
import 'package:to_do_app/core/constants/color_class.dart';
import 'package:to_do_app/core/constants/textstyle_class.dart';
import 'package:to_do_app/core/utils/app_utils.dart';
import 'package:to_do_app/features/auth/data/local_auth_source.dart';
import 'package:to_do_app/features/profile/bloc/profile_bloc.dart';
import 'package:to_do_app/features/profile/bloc/profile_event.dart';
import 'package:to_do_app/features/profile/bloc/profile_state.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _usernameController;
  late TextEditingController _dateOfBirthController;
  String? _profilePicturePath;
  DateTime? _selectedDateOfBirth;
  bool _hasUnsavedChanges = false;
  String? _originalUsername;
  String? _originalProfilePicturePath;
  DateTime? _originalDateOfBirth;
  int? _profileId;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _dateOfBirthController = TextEditingController();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    debugPrint('EditProfileScreen: Loading profile data');
    final email = await LocalAuth.email;
    if (email != null) {
      context.read<ProfileBloc>().add(LoadProfile(email));
    }
  }

  void _initializeForm(dynamic profile) {
    debugPrint('EditProfileScreen: Initializing form with profile data');
    _profileId = profile.id;
    _usernameController.text = profile.username;
    _profilePicturePath = profile.profilePicturePath;
    _selectedDateOfBirth = profile.dateOfBirth;
    
    // Store original values for change detection
    _originalUsername = profile.username;
    _originalProfilePicturePath = profile.profilePicturePath;
    _originalDateOfBirth = profile.dateOfBirth;
    
    if (_selectedDateOfBirth != null) {
      _dateOfBirthController.text = '${_selectedDateOfBirth!.year}-${_selectedDateOfBirth!.month.toString().padLeft(2, '0')}-${_selectedDateOfBirth!.day.toString().padLeft(2, '0')}';
    }
    
    _hasUnsavedChanges = false;
  }

  void _checkForChanges() {
    final hasChanges = _usernameController.text != _originalUsername ||
        _profilePicturePath != _originalProfilePicturePath ||
        _selectedDateOfBirth != _originalDateOfBirth;
    
    if (hasChanges != _hasUnsavedChanges) {
      setState(() {
        _hasUnsavedChanges = hasChanges;
      });
    }
  }

  Future<bool> _onWillPop() async {
    if (!_hasUnsavedChanges) {
      return true;
    }

    debugPrint('EditProfileScreen: Unsaved changes detected, showing confirmation');
    final shouldLeave = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: ColorClass.kCardColor,
        title: Text(
          'Unsaved Changes',
          style: TextStyleClass.primaryFont600(18, ColorClass.kTextColor),
        ),
        content: Text(
          'You have unsaved changes. Are you sure you want to leave?',
          style: TextStyleClass.primaryFont400(14, ColorClass.kTextSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: TextStyleClass.primaryFont500(14, ColorClass.kTextSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorClass.stateError,
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

  Future<void> _pickImage() async {
    debugPrint('EditProfileScreen: Opening image picker');
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _profilePicturePath = image.path;
          _checkForChanges();
        });
        debugPrint('EditProfileScreen: Image selected: ${image.path}');
      }
    } catch (e) {
      debugPrint('EditProfileScreen: Error picking image: $e');
      if (mounted) {
        AppUtils.showToast(context, message: 'Failed to pick image');
      }
    }
  }

  Future<void> _selectDateOfBirth() async {
    debugPrint('EditProfileScreen: Opening date picker');
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateOfBirth ?? DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: ColorClass.kPrimaryColor,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDateOfBirth = picked;
        _dateOfBirthController.text = '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
        _checkForChanges();
      });
      debugPrint('EditProfileScreen: Date selected: ${_dateOfBirthController.text}');
    }
  }

  int _calculateProfileCompleteness(dynamic profile) {
    int completeness = 0;
    if (profile.username.isNotEmpty) completeness += 33;
    if (profile.profilePicturePath != null && profile.profilePicturePath!.isNotEmpty) completeness += 33;
    if (profile.dateOfBirth != null) completeness += 34;
    return completeness;
  }

  void _saveProfile() {
    if (!_formKey.currentState!.validate()) {
      debugPrint('EditProfileScreen: Form validation failed');
      return;
    }

    if (_profileId == null) {
      debugPrint('EditProfileScreen: Profile ID is null');
      AppUtils.showToast(context, message: 'Profile not loaded');
      return;
    }

    debugPrint('EditProfileScreen: Saving profile changes');
    final XFile? profilePicture = _profilePicturePath != null && 
        _profilePicturePath != _originalProfilePicturePath
        ? XFile(_profilePicturePath!)
        : null;

    context.read<ProfileBloc>().add(
      UpdateProfile(
        profileId: _profileId!,
        username: _usernameController.text.trim(),
        profilePicture: profilePicture,
        dateOfBirth: _selectedDateOfBirth,
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _dateOfBirthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          final shouldPop = await _onWillPop();
          if (shouldPop && mounted) {
            Navigator.pop(context);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Edit Profile',
            style: TextStyleClass.primaryFont600(20, ColorClass.kTextColor),
          ),
          actions: [
            if (_hasUnsavedChanges)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Center(
                  child: Text(
                    'Unsaved',
                    style: TextStyleClass.primaryFont500(
                      12,
                      ColorClass.stateError,
                    ),
                  ),
                ),
              ),
          ],
        ),
        body: BackgroundPattern(
          child: BlocConsumer<ProfileBloc, ProfileState>(
            listener: (context, state) async {
              if (state is ProfileLoaded) {
                _initializeForm(state.profile);
              } else if (state is ProfileUpdated) {
                debugPrint('EditProfileScreen: Profile updated successfully');
                AppUtils.showToast(context, message: 'Profile updated successfully');
                setState(() {
                  _hasUnsavedChanges = false;
                  _originalUsername = state.profile.username;
                  _originalProfilePicturePath = state.profile.profilePicturePath;
                  _originalDateOfBirth = state.profile.dateOfBirth;
                });
                // Update the form with new values
                _initializeForm(state.profile);
                
                // Reload profile in drawer by triggering a reload from local DB
                final email = await LocalAuth.email;
                if (email != null) {
                  debugPrint('EditProfileScreen: Reloading profile in drawer from local DB');
                  context.read<ProfileBloc>().add(LoadProfile(email));
                }
                
                // Navigate back after successful update
                if (mounted) {
                  Navigator.pop(context);
                }
              } else if (state is ProfileError) {
                debugPrint('EditProfileScreen: Error: ${state.message}');
                AppUtils.showToast(context, message: state.message);
              }
            },
            builder: (context, state) {
              if (state is ProfileLoading && _profileId == null) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: ColorClass.kPrimaryColor,
                  ),
                );
              }

              dynamic currentProfile;
              if (state is ProfileLoaded) {
                currentProfile = state.profile;
              } else if (state is ProfileUpdated) {
                currentProfile = state.profile;
              } else if (_profileId == null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: ColorClass.stateError,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Failed to load profile',
                        style: TextStyleClass.primaryFont600(
                          18,
                          ColorClass.kTextColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _loadProfile,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              final completeness = currentProfile != null
                  ? _calculateProfileCompleteness(currentProfile)
                  : 0;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Profile Completeness Indicator
                      if (currentProfile != null) ...[
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: ColorClass.kCardColor,
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
                                    style: TextStyleClass.primaryFont600(
                                      16,
                                      ColorClass.kTextColor,
                                    ),
                                  ),
                                  Text(
                                    '$completeness%',
                                    style: TextStyleClass.primaryFont600(
                                      16,
                                      ColorClass.kPrimaryColor,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: LinearProgressIndicator(
                                  value: completeness / 100,
                                  minHeight: 8,
                                  backgroundColor: ColorClass.neutral200,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    ColorClass.kPrimaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Profile Picture
                      Center(
                        child: Stack(
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: ColorClass.kPrimaryColor,
                                  width: 3,
                                ),
                                color: ColorClass.neutral200,
                              ),
                              child: _profilePicturePath != null &&
                                      File(_profilePicturePath!).existsSync()
                                  ? ClipOval(
                                      child: Image.file(
                                        File(_profilePicturePath!),
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Icon(
                                      Icons.person,
                                      size: 60,
                                      color: ColorClass.kTextSecondary,
                                    ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: ColorClass.kPrimaryColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: ColorClass.kCardColor,
                                    width: 2,
                                  ),
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  onPressed: _pickImage,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Username Field
                      Text(
                        'Username',
                        style: TextStyleClass.primaryFont500(
                          14,
                          ColorClass.kTextColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          hintText: 'Enter username',
                          prefixIcon: const Icon(Icons.person_outline),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Username is required';
                          }
                          if (value.trim().length < 3) {
                            return 'Username must be at least 3 characters';
                          }
                          return null;
                        },
                        onChanged: (_) => _checkForChanges(),
                      ),
                      const SizedBox(height: 24),

                      // Date of Birth Field
                      Text(
                        'Date of Birth',
                        style: TextStyleClass.primaryFont500(
                          14,
                          ColorClass.kTextColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _dateOfBirthController,
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: 'Select date of birth',
                          prefixIcon: const Icon(Icons.calendar_today_outlined),
                        ),
                        onTap: _selectDateOfBirth,
                      ),
                      const SizedBox(height: 32),

                      // Save Button
                      ElevatedButton(
                        onPressed: _hasUnsavedChanges ? _saveProfile : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorClass.kPrimaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: state is ProfileLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Text(
                                'Save Changes',
                                style: TextStyleClass.primaryFont600(
                                  16,
                                  Colors.white,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

