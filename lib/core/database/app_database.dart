import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '../../features/home/data/local/todo_table.dart';
import '../../features/auth/data/database/profiles_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Profiles, TodoTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // Profile operations
  Future<int> insertProfile(ProfilesCompanion profile) {
    debugPrint('Inserting profile: ${profile.username.value}');
    return into(profiles).insert(profile);
  }

  Future<Profile?> getProfileByUsername(String username) {
    debugPrint('Getting profile by username: $username');
    return (select(profiles)..where((p) => p.username.equals(username))).getSingleOrNull();
  }

  Future<Profile?> getProfileByEmail(String email) {
    debugPrint('Getting profile by email: $email');
    return (select(profiles)..where((p) => p.email.equals(email))).getSingleOrNull();
  }

  Future<List<Profile>> getAllProfiles() {
    debugPrint('Getting all profiles');
    return select(profiles).get();
  }

  Future<bool> updateProfile(int id, ProfilesCompanion updated) {
    debugPrint('Updating profile with id: $id');
    return (update(profiles)..where((p) => p.id.equals(id))).write(updated).then((value) {
      debugPrint('Profile updated: $value');
      return value > 0;
    });
  }

  Future<bool> deleteProfile(int id) {
    debugPrint('Deleting profile with id: $id');
    return (delete(profiles)..where((p) => p.id.equals(id))).go().then((value) {
      debugPrint('Profile deleted: $value');
      return value > 0;
    });
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'app.db'));
    return NativeDatabase(file);
  });
}

