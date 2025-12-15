import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import 'todo_table.dart';

part 'todo_dao.g.dart';

@DriftAccessor(tables: [TodoTable])
class TodoDao extends DatabaseAccessor<AppDatabase>
    with _$TodoDaoMixin {
  TodoDao(AppDatabase db) : super(db);

  /// Save page data
  Future<void> insertTodos(List<TodoTableCompanion> todos) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(todoTable, todos);
    });
  }

  /// Pagination from DB
  Future<List<TodoTableData>> fetchTodos({
    required int limit,
    required int offset,
  }) {
    return (select(todoTable)
          ..limit(limit, offset: offset))
        .get();
  }

  /// Clear all (for pull-to-refresh)
  Future<void> clearTodos() => delete(todoTable).go();

  /// Toggle favorite status
  Future<void> toggleFavorite(int id, bool isFavorite) async {
    await (update(todoTable)..where((t) => t.id.equals(id)))
        .write(TodoTableCompanion(isFavorite: Value(isFavorite)));
  }

  /// Get favorite todos
  Future<List<TodoTableData>> getFavoriteTodos() {
    return (select(todoTable)..where((t) => t.isFavorite.equals(true))).get();
  }
}

