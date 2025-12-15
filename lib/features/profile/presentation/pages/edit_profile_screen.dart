import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:to_do_app/core/components/background_screen.dart';
import 'package:to_do_app/core/constants/color_class.dart';
import 'package:to_do_app/core/constants/textstyle_class.dart';
import 'package:to_do_app/core/utils/app_utils.dart';
import 'package:to_do_app/core/utils/image_picker_utils.dart';
import 'package:to_do_app/features/auth/data/local_auth_source.dart';
import 'package:to_do_app/features/profile/bloc/profile_bloc.dart';
import 'package:to_do_app/features/profile/bloc/profile_event.dart';
import 'package:to_do_app/features/profile/bloc/profile_state.dart';
import '../widgets/profile_completeness_indicator.dart';
import '../widgets/profile_picture_picker.dart';
import '../widgets/username_field.dart';
import '../widgets/date_of_birth_field.dart';
import '../widgets/save_profile_button.dart';
import '../widgets/profile_error_state.dart';
import '../widgets/unsaved_changes_dialog.dart';
import '../widgets/profile_utils.dart';

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
      _dateOfBirthController.text = ProfileUtils.formatDateOfBirth(_selectedDateOfBirth!);
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
    return await UnsavedChangesDialog.show(context);
  }

  Future<void> _pickImage() async {
    debugPrint('EditProfileScreen: Opening image picker');
    final imagePath = await ImagePickerUtils.pickImage(
      source: ImageSource.gallery,
      context: context,
    );

    if (imagePath != null && mounted) {
      setState(() {
        _profilePicturePath = imagePath;
        _checkForChanges();
      });
      debugPrint('EditProfileScreen: Image selected: $imagePath');
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
        _dateOfBirthController.text = ProfileUtils.formatDateOfBirth(picked);
        _checkForChanges();
      });
      debugPrint('EditProfileScreen: Date selected: ${_dateOfBirthController.text}');
    }
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
                return ProfileErrorState(onRetry: _loadProfile);
              }

              final completeness = currentProfile != null
                  ? ProfileUtils.calculateCompleteness(
                      username: currentProfile.username,
                      profilePicturePath: currentProfile.profilePicturePath,
                      dateOfBirth: currentProfile.dateOfBirth,
                    )
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
                        ProfileCompletenessIndicator(completeness: completeness),
                        const SizedBox(height: 24),
                      ],

                      // Profile Picture
                      ProfilePicturePicker(
                        profilePicturePath: _profilePicturePath,
                        onPickImage: _pickImage,
                      ),
                      const SizedBox(height: 32),

                      // Username Field
                      UsernameField(
                        controller: _usernameController,
                        onChanged: (_) => _checkForChanges(),
                      ),
                      const SizedBox(height: 24),

                      // Date of Birth Field
                      DateOfBirthField(
                        controller: _dateOfBirthController,
                        onTap: _selectDateOfBirth,
                      ),
                      const SizedBox(height: 32),

                      // Save Button
                      SaveProfileButton(
                        isEnabled: _hasUnsavedChanges,
                        isLoading: state is ProfileLoading,
                        onPressed: _saveProfile,
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

