import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_urls.dart';
import '../models/profile_model.dart';

class ProfileRemoteSource {
  final http.Client client;

  ProfileRemoteSource(this.client);

  Future<ProfileModel?> fetchProfileByEmail(String email) async {
    debugPrint('ProfileRemoteSource: Fetching profile from API for email: $email');
    try {
      final url = Uri.parse(ApiUrls.profileByEmail(email));
      final response = await client.get(url);

      if (response.statusCode == 200) {
        final List list = json.decode(response.body);
        if (list.isNotEmpty) {
          final profileJson = list.first as Map<String, dynamic>;
          debugPrint('ProfileRemoteSource: Profile fetched successfully from API');
          return ProfileModel.fromJson(profileJson);
        }
        debugPrint('ProfileRemoteSource: No profile found in API response');
        return null;
      } else {
        debugPrint('ProfileRemoteSource: API error with status code: ${response.statusCode}');
        throw Exception('API error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('ProfileRemoteSource: Error fetching profile from API: $e');
      // Return null if API fails - will fallback to local DB
      return null;
    }
  }

  Future<ProfileModel?> updateProfile({
    required int id,
    required String username,
    String? profilePicturePath,
    DateTime? dateOfBirth,
  }) async {
    debugPrint('ProfileRemoteSource: Updating profile in API with id: $id');
    try {
      final url = Uri.parse(ApiUrls.updateProfile(id));
      final body = json.encode({
        'username': username,
        'profilePicturePath': profilePicturePath,
        'dateOfBirth': dateOfBirth?.toIso8601String(),
      });

      final response = await client.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        final profileJson = json.decode(response.body) as Map<String, dynamic>;
        debugPrint('ProfileRemoteSource: Profile updated successfully in API');
        return ProfileModel.fromJson(profileJson);
      } else {
        debugPrint('ProfileRemoteSource: API update error with status code: ${response.statusCode}');
        throw Exception('API update error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('ProfileRemoteSource: Error updating profile in API: $e');
      // Return null if API fails - will fallback to local DB only
      return null;
    }
  }
}

