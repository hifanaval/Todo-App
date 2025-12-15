import 'package:drift/drift.dart';

class TodoTable extends Table {
  IntColumn get id => integer()(); // API id
  TextColumn get title => text()();
  BoolColumn get completed => boolean()();
  BoolColumn get isFavorite =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

