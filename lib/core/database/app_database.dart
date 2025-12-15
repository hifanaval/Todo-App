import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '../../features/home/data/local/todo_table.dart';
import '../../features/auth/data/database/profiles_table.dart';
import '../../features/auth/data/database/saved_accounts_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Profiles, TodoTable, SavedAccounts])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onUpgrade: (m, from, to) async {
        if (from < 2) {
          // Add saved_accounts table
          await m.createTable(savedAccounts);
        }
        // Note: The unique constraint on email is defined in the table definition
        // SQLite doesn't support adding unique constraints to existing columns via ALTER TABLE
        // The constraint will be applied when the table is recreated or for new installations
        // For existing databases, duplicates are handled in getAllSavedAccounts() method
      },
    );
  }

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

  // Saved Accounts operations
  Future<int> insertSavedAccount(SavedAccountsCompanion account) async {
    debugPrint('Inserting saved account: ${account.email.value}');
    
    // Check if account already exists
    final existing = await getSavedAccountByEmail(account.email.value);
    if (existing != null) {
      debugPrint('Account already exists, updating instead of inserting');
      // Update existing account (keep original ID and createdAt)
      final updateCompanion = SavedAccountsCompanion(
        email: account.email,
        password: account.password,
        username: account.username,
        fullName: account.fullName,
        profilePicturePath: account.profilePicturePath,
        lastLoginAt: account.lastLoginAt,
        // Don't update id and createdAt
      );
      return (update(savedAccounts)..where((a) => a.email.equals(account.email.value)))
          .write(updateCompanion);
    }
    
    // Insert new account
    return into(savedAccounts).insert(account);
  }

  Future<SavedAccount?> getSavedAccountByEmail(String email) {
    debugPrint('Getting saved account by email: $email');
    return (select(savedAccounts)..where((a) => a.email.equals(email))).getSingleOrNull();
  }

  Future<List<SavedAccount>> getAllSavedAccounts() async {
    debugPrint('Getting all saved accounts');
    final accounts = await (select(savedAccounts)..orderBy([(a) => OrderingTerm.desc(a.lastLoginAt)])).get();
    
    // Remove duplicates by email (keep the most recent one)
    final uniqueAccounts = <String, SavedAccount>{};
    for (final account in accounts) {
      if (!uniqueAccounts.containsKey(account.email) ||
          account.lastLoginAt.isAfter(uniqueAccounts[account.email]!.lastLoginAt)) {
        uniqueAccounts[account.email] = account;
      }
    }
    
    // Delete duplicates from database
    final duplicateEmails = accounts
        .where((a) => uniqueAccounts[a.email]?.id != a.id)
        .map((a) => a.id)
        .toList();
    
    if (duplicateEmails.isNotEmpty) {
      debugPrint('Removing ${duplicateEmails.length} duplicate saved accounts');
      for (final id in duplicateEmails) {
        await deleteSavedAccount(id);
      }
    }
    
    return uniqueAccounts.values.toList()
      ..sort((a, b) => b.lastLoginAt.compareTo(a.lastLoginAt));
  }

  Future<bool> deleteSavedAccount(int id) {
    debugPrint('Deleting saved account with id: $id');
    return (delete(savedAccounts)..where((a) => a.id.equals(id))).go().then((value) {
      debugPrint('Saved account deleted: $value');
      return value > 0;
    });
  }

  Future<bool> deleteSavedAccountByEmail(String email) {
    debugPrint('Deleting saved account by email: $email');
    return (delete(savedAccounts)..where((a) => a.email.equals(email))).go().then((value) {
      debugPrint('Saved account deleted: $value');
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

