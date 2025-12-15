import 'package:drift/drift.dart';
import '../remote/todo_remote_source.dart';
import '../local/todo_dao.dart';
import '../models/todo_model.dart';
import '../../../../core/constants/todo_constants.dart';
import '../../../../core/database/app_database.dart';

class TodoRepository {
  final TodoRemoteSource remote;
  final TodoDao local;

  TodoRepository(this.remote, this.local);

  /// Load from DB first
  Future<List<TodoTableData>> loadFromDb({
    required int limit,
    required int offset,
  }) {
    return local.fetchTodos(limit: limit, offset: offset);
  }

  /// Fetch from API and save
  Future<List<TodoDataModel>> fetchAndSave({
    required int page,
    required int limit,
  }) async {
    final todos = await remote.fetchTodos(page: page, limit: limit);

    await local.insertTodos(
      todos.map((e) => TodoTableCompanion(
        id: Value(e.id ?? 0),
        title: Value(e.title ?? ''),
        completed: Value(e.completed ?? false),
        isFavorite: const Value(false),
      )).toList(),
    );

    return todos;
  }

  Future<void> refresh() async {
    await local.clearTodos();
    await fetchAndSave(page: 0, limit: TodoConstants.todoPageSize);
  }

  Future<void> toggleFavorite(int id, bool isFavorite) async {
    await local.toggleFavorite(id, isFavorite);
  }

  Future<List<TodoTableData>> getFavoriteTodos() {
    return local.getFavoriteTodos();
  }
}

