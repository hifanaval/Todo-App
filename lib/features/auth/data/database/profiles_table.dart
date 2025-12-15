import 'package:drift/drift.dart';

class Profiles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get username => text().withLength(min: 3, max: 50)();
  TextColumn get fullName => text().withLength(min: 2, max: 100)();
  TextColumn get email => text().withLength(min: 5, max: 100)();
  TextColumn get password => text().withLength(min: 6, max: 100)();
  TextColumn get profilePicturePath => text().nullable()();
  DateTimeColumn get dateOfBirth => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

