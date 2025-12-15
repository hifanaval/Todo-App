import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/core/database/app_database.dart';
import 'package:to_do_app/features/profile/data/repository/profile_repository.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _repository;

  ProfileBloc({required ProfileRepository repository})
      : _repository = repository,
        super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
    on<ResetProfileState>(_onResetProfileState);
  }

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    debugPrint('ProfileBloc: Loading profile for email: ${event.email}, fromApi: ${event.fromApi}');
    emit(ProfileLoading());

    try {
      Profile? profile;
      
      if (event.fromApi) {
        // Fetch from API first, then save to local DB
        debugPrint('ProfileBloc: Fetching profile from API');
        profile = await _repository.fetchProfileFromApi(event.email);
      } else {
        // Load from local DB only
        debugPrint('ProfileBloc: Loading profile from local DB');
        profile = await _repository.getProfileFromLocal(event.email);
      }

      if (profile == null) {
        debugPrint('ProfileBloc: Profile not found');
        emit(ProfileError('Profile not found'));
        return;
      }

      debugPrint('ProfileBloc: Profile loaded successfully');
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
      // Get current profile from local DB first to get email for fallback
      final currentProfile = await _repository.getProfileFromLocal('');
      String? currentUsername;
      
      if (currentProfile != null && currentProfile.id == event.profileId) {
        currentUsername = currentProfile.username;
      } else {
        // Fallback: get from all profiles
        final allProfiles = await _repository.local.getAllProfiles();
        final profile = allProfiles.firstWhere(
          (p) => p.id == event.profileId,
          orElse: () => throw Exception('Profile not found'),
        );
        currentUsername = profile.username;
      }

      // Use repository to update both API and local DB
      final updatedProfile = await _repository.updateProfile(
        profileId: event.profileId,
        username: event.username != null ? event.username! : currentUsername,
        profilePicturePath: event.profilePicture?.path,
        dateOfBirth: event.dateOfBirth,
      );

      if (updatedProfile == null) {
        debugPrint('ProfileBloc: Failed to update profile');
        emit(ProfileError('Failed to update profile'));
        return;
      }

      debugPrint('ProfileBloc: Profile updated successfully in API and local DB');
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

