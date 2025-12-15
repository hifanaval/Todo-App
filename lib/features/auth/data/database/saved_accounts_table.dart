import 'package:drift/drift.dart';

class SavedAccounts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get email => text().withLength(min: 5, max: 100).unique()();
  TextColumn get password => text().withLength(min: 6, max: 100)();
  TextColumn get username => text().withLength(min: 3, max: 50).nullable()();
  TextColumn get fullName => text().withLength(min: 2, max: 100).nullable()();
  TextColumn get profilePicturePath => text().nullable()();
  DateTimeColumn get lastLoginAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

