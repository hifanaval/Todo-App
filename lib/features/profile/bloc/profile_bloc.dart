import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drift/drift.dart';
import 'package:to_do_app/core/database/app_database.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AppDatabase _database;

  ProfileBloc({required AppDatabase database})
      : _database = database,
        super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
    on<ResetProfileState>(_onResetProfileState);
  }

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    debugPrint('ProfileBloc: Loading profile from local DB for email: ${event.email}');
    emit(ProfileLoading());

    try {
      // Load from local DB (data stored during registration)
      final profile = await _database.getProfileByEmail(event.email);

      if (profile == null) {
        debugPrint('ProfileBloc: Profile not found in local DB');
        emit(ProfileError('Profile not found'));
        return;
      }

      debugPrint('ProfileBloc: Profile loaded successfully from local DB');
      emit(ProfileLoaded(profile));
    } catch (e) {
      debugPrint('ProfileBloc: Error loading profile: $e');
      emit(ProfileError('Failed to load profile: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfile event,
    Emitter<ProfileState> emit,
  ) async {
    debugPrint('ProfileBloc: Updating profile with id: ${event.profileId}');
    emit(ProfileLoading());

    try {
      // Get current profile from local DB
      final allProfiles = await _database.getAllProfiles();
      final currentProfile = allProfiles.firstWhere(
        (p) => p.id == event.profileId,
        orElse: () => throw Exception('Profile not found'),
      );

      // Prepare update companion - only update fields that are provided
      final updateCompanion = ProfilesCompanion(
        username: event.username != null
            ? Value(event.username!)
            : Value(currentProfile.username),
        profilePicturePath: event.profilePicture != null
            ? Value(event.profilePicture!.path)
            : Value(currentProfile.profilePicturePath),
        dateOfBirth: event.dateOfBirth != null
            ? Value(event.dateOfBirth!)
            : Value(currentProfile.dateOfBirth),
      );

      // Update profile in local DB
      final success = await _database.updateProfile(event.profileId, updateCompanion);
      if (!success) {
        debugPrint('ProfileBloc: Failed to update profile in local DB');
        emit(ProfileError('Failed to update profile'));
        return;
      }

      // Reload updated profile from local DB
      final updatedProfiles = await _database.getAllProfiles();
      final updatedProfile = updatedProfiles.firstWhere((p) => p.id == event.profileId);

      debugPrint('ProfileBloc: Profile updated successfully in local DB');
      emit(ProfileUpdated(updatedProfile));
    } catch (e) {
      debugPrint('ProfileBloc: Error updating profile: $e');
      emit(ProfileError('Failed to update profile: ${e.toString()}'));
    }
  }

  Future<void> _onResetProfileState(
    ResetProfileState event,
    Emitter<ProfileState> emit,
  ) async {
    debugPrint('ProfileBloc: Resetting profile state');
    emit(ProfileInitial());
  }
}

