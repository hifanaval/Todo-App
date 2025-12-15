import 'package:flutter/foundation.dart';
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

  /// Load from DB first (for initial display)
  Future<List<TodoTableData>> loadFromDb({
    required int limit,
    required int offset,
  }) async {
    debugPrint('📦 TodoRepository: Loading todos from DB - limit: $limit, offset: $offset');
    final todos = await local.fetchTodos(limit: limit, offset: offset);
    debugPrint('📦 TodoRepository: Loaded ${todos.length} todos from DB');
    return todos;
  }

  /// Fetch todos from API and save to local DB
  /// Uses skip/limit pattern: skip = number of items to skip, limit = number to fetch
  Future<List<TodoDataModel>> fetchTodosFromApi({
    required int skip,
    required int limit,
  }) async {
    debugPrint('🌐 [TodoRepository] fetchTodosFromApi called - skip: $skip, limit: $limit');
    
    // Calculate page number (page 0 = skip 0, page 1 = skip 20, etc.)
    final page = skip ~/ limit;
    debugPrint('🌐 [TodoRepository] Calculated page: $page (skip: $skip, limit: $limit)');
    
    try {
      debugPrint('🌐 [TodoRepository] Calling remote.fetchTodos(page: $page, limit: $limit)');
      final todos = await remote.fetchTodos(page: page, limit: limit);
      debugPrint('🌐 [TodoRepository] remote.fetchTodos returned ${todos.length} todos');

      if (todos.isNotEmpty) {
        // Save to local DB
        await local.insertTodos(
          todos.map((e) => TodoTableCompanion(
            id: Value(e.id ?? 0),
            title: Value(e.title ?? ''),
            completed: Value(e.completed ?? false),
            isFavorite: const Value(false),
          )).toList(),
        );
        debugPrint('💾 TodoRepository: Saved ${todos.length} todos to local DB');
      }

      return todos;
    } on NetworkException {
      debugPrint('❌ TodoRepository: Network error fetching todos');
      rethrow;
    } on ApiException {
      debugPrint('❌ TodoRepository: API error fetching todos');
      rethrow;
    } catch (e) {
      debugPrint('❌ TodoRepository: Unexpected error: $e');
      throw Exception('Failed to fetch and save todos: ${e.toString()}');
    }
  }

  /// Refresh: Clear DB and fetch fresh data from API
  Future<void> refresh() async {
    debugPrint('🔄 TodoRepository: Refreshing todos - clearing DB and fetching from API');
    await local.clearTodos();
    debugPrint('🧹 TodoRepository: Cleared todos from DB');
    
    try {
      // Fetch first page
      await fetchTodosFromApi(skip: 0, limit: TodoConstants.todoPageSize);
      debugPrint('✅ TodoRepository: Refresh completed successfully');
    } on NetworkException {
      debugPrint('❌ TodoRepository: Network error during refresh');
      rethrow;
    } on ApiException {
      debugPrint('❌ TodoRepository: API error during refresh');
      rethrow;
    } catch (e) {
      debugPrint('❌ TodoRepository: Error during refresh: $e');
      throw Exception('Failed to refresh todos: ${e.toString()}');
    }
  }

  Future<void> toggleFavorite(int id, bool isFavorite) async {
    await local.toggleFavorite(id, isFavorite);
  }

  Future<void> toggleCompleted(int id, bool completed) async {
    await local.toggleCompleted(id, completed);
  }

  Future<void> deleteTodo(int id) async {
    await local.deleteTodo(id);
  }

  Future<List<TodoTableData>> getFavoriteTodos() {
    return local.getFavoriteTodos();
  }
}

