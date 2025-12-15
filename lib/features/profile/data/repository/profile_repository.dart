import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:to_do_app/core/database/app_database.dart';
import '../remote/profile_remote_source.dart';

class ProfileRepository {
  final ProfileRemoteSource remote;
  final AppDatabase local;

  ProfileRepository(this.remote, this.local);

  /// Fetch profile from API first, then save to local DB
  Future<Profile?> fetchProfileFromApi(String email) async {
    debugPrint('ProfileRepository: Fetching profile from API for email: $email');
    try {
      final profileModel = await remote.fetchProfileByEmail(email);
      
      if (profileModel != null) {
        debugPrint('ProfileRepository: Profile fetched from API, saving to local DB');
        // Save to local DB
        final profileCompanion = ProfilesCompanion.insert(
          username: profileModel.username,
          fullName: profileModel.fullName,
          email: profileModel.email,
          password: '', // Password not available from API, use empty string
          profilePicturePath: profileModel.profilePicturePath != null
              ? Value(profileModel.profilePicturePath!)
              : const Value.absent(),
          dateOfBirth: profileModel.dateOfBirth != null
              ? Value(profileModel.dateOfBirth!)
              : const Value.absent(),
        );

        // Check if profile exists in local DB
        final existingProfile = await local.getProfileByEmail(email);
        if (existingProfile != null) {
          // Update existing profile
          await local.updateProfile(existingProfile.id, profileCompanion);
          debugPrint('ProfileRepository: Profile updated in local DB');
        } else {
          // Insert new profile
          await local.insertProfile(profileCompanion);
          debugPrint('ProfileRepository: Profile inserted into local DB');
        }

        // Return the updated profile from local DB
        return await local.getProfileByEmail(email);
      }
      
      debugPrint('ProfileRepository: No profile found in API, returning null');
      return null;
    } catch (e) {
      debugPrint('ProfileRepository: Error fetching profile from API: $e');
      // Fallback to local DB
      return await local.getProfileByEmail(email);
    }
  }

  /// Update profile in API and local DB
  Future<Profile?> updateProfile({
    required int profileId,
    required String username,
    String? profilePicturePath,
    DateTime? dateOfBirth,
  }) async {
    debugPrint('ProfileRepository: Updating profile with id: $profileId');
    
    try {
      // First, try to update in API
      await remote.updateProfile(
        id: profileId,
        username: username,
        profilePicturePath: profilePicturePath,
        dateOfBirth: dateOfBirth,
      );

      // Update local DB regardless of API success
      final allProfiles = await local.getAllProfiles();
      final currentProfile = allProfiles.firstWhere(
        (p) => p.id == profileId,
        orElse: () => throw Exception('Profile not found in local DB'),
      );

      final updateCompanion = ProfilesCompanion(
        username: Value(username),
        profilePicturePath: profilePicturePath != null
            ? Value(profilePicturePath)
            : Value(currentProfile.profilePicturePath),
        dateOfBirth: dateOfBirth != null
            ? Value(dateOfBirth)
            : Value(currentProfile.dateOfBirth),
      );

      final success = await local.updateProfile(profileId, updateCompanion);
      if (!success) {
        debugPrint('ProfileRepository: Failed to update profile in local DB');
        throw Exception('Failed to update profile in local DB');
      }

      // Return updated profile from local DB
      final updatedProfiles = await local.getAllProfiles();
      final newProfile = updatedProfiles.firstWhere((p) => p.id == profileId);
      
      debugPrint('ProfileRepository: Profile updated successfully in both API and local DB');
      return newProfile;
    } catch (e) {
      debugPrint('ProfileRepository: Error updating profile: $e');
      // Even if API fails, try to update local DB
      try {
        final allProfiles = await local.getAllProfiles();
        final currentProfile = allProfiles.firstWhere(
          (p) => p.id == profileId,
          orElse: () => throw Exception('Profile not found'),
        );

        final updateCompanion = ProfilesCompanion(
          username: Value(username),
          profilePicturePath: profilePicturePath != null
              ? Value(profilePicturePath)
              : Value(currentProfile.profilePicturePath),
          dateOfBirth: dateOfBirth != null
              ? Value(dateOfBirth)
              : Value(currentProfile.dateOfBirth),
        );

        await local.updateProfile(profileId, updateCompanion);
        final updatedProfiles = await local.getAllProfiles();
        final newProfile = updatedProfiles.firstWhere((p) => p.id == profileId);
        debugPrint('ProfileRepository: Profile updated in local DB only (API failed)');
        return newProfile;
      } catch (localError) {
        debugPrint('ProfileRepository: Error updating local DB: $localError');
        rethrow;
      }
    }
  }

  /// Get profile from local DB
  Future<Profile?> getProfileFromLocal(String email) async {
    debugPrint('ProfileRepository: Getting profile from local DB for email: $email');
    return await local.getProfileByEmail(email);
  }
}

