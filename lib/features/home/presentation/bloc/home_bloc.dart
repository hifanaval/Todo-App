import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';
import '../../data/repository/todo_repository.dart';
import '../../data/remote/todo_remote_source.dart';
import '../../../../core/constants/todo_constants.dart';
import '../../../../core/utils/app_utils.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final TodoRepository repository;
  int _currentSkip = 0; // Track how many items we've loaded

  HomeBloc(this.repository)
      : super(HomeState(
          todos: [],
          isLoading: false,
          isLoadingMore: false,
          hasMore: true,
          hasTriedApiAndFailed: false,
        )) {
    on<LoadInitialTodos>(_onLoadInitialTodos);
    on<LoadMoreTodos>(_onLoadMoreTodos);
    on<RefreshTodos>(_onRefreshTodos);
    on<ToggleTodo>(_onToggleTodo);
    on<DeleteTodo>(_onDeleteTodo);
    on<ToggleFavorite>(_onToggleFavorite);
    on<ClearTodosEvent>(_onClearTodos);
  }

  /// Load initial todos - shows DB data first, then fetches from API if empty
  Future<void> _onLoadInitialTodos(
    LoadInitialTodos event,
    Emitter<HomeState> emit,
  ) async {
    debugPrint('🏠 HomeBloc: Loading initial todos');
    emit(state.copyWith(isLoading: true));
    _currentSkip = 0;

    try {
      // Step 1: Try loading from local DB first
      final dbTodos = await repository.loadFromDb(
        limit: TodoConstants.todoPageSize,
        offset: 0,
      );

      if (dbTodos.isNotEmpty) {
        // ✅ Data exists in DB - show it immediately
        debugPrint('📦 HomeBloc: Showing ${dbTodos.length} todos from DB');
        emit(state.copyWith(
          todos: dbTodos,
          isLoading: false,
          hasTriedApiAndFailed: false,
          hasMore: dbTodos.length == TodoConstants.todoPageSize, // Assume more if we got a full page
        ));
        _currentSkip = dbTodos.length;
      } else {
        // ❌ No data in DB - fetch from API
        debugPrint('📡 HomeBloc: No DB data, fetching from API');
        try {
          final newTodos = await repository.fetchTodosFromApi(
            skip: 0,
            limit: TodoConstants.todoPageSize,
          );
          
          // Reload from DB to get the saved data
          final newDbTodos = await repository.loadFromDb(
            limit: TodoConstants.todoPageSize,
            offset: 0,
          );
          
          debugPrint('✅ HomeBloc: Fetched ${newTodos.length} todos from API');
          emit(state.copyWith(
            todos: newDbTodos,
            isLoading: false,
            hasMore: newTodos.length == TodoConstants.todoPageSize,
            hasTriedApiAndFailed: false,
          ));
          _currentSkip = newDbTodos.length;
        } on NetworkException catch (e) {
          debugPrint('❌ HomeBloc: Network error: ${e.message}');
          AppUtils.showToast(null, message: e.message);
          emit(state.copyWith(
            isLoading: false,
            hasTriedApiAndFailed: true,
          ));
        } on ApiException catch (e) {
          debugPrint('❌ HomeBloc: API error: ${e.message}');
          AppUtils.showToast(null, message: e.message);
          emit(state.copyWith(
            isLoading: false,
            hasTriedApiAndFailed: true,
          ));
        } catch (e) {
          debugPrint('❌ HomeBloc: Error loading initial todos: $e');
          AppUtils.showToast(null, message: 'Failed to load todos. Please try again.');
          emit(state.copyWith(
            isLoading: false,
            hasTriedApiAndFailed: true,
          ));
        }
      }
    } catch (e) {
      debugPrint('❌ HomeBloc: Error loading from DB: $e');
      emit(state.copyWith(
        isLoading: false,
        hasTriedApiAndFailed: true,
      ));
    }
  }

  /// Load more todos - pagination using skip/limit
  Future<void> _onLoadMoreTodos(
    LoadMoreTodos event,
    Emitter<HomeState> emit,
  ) async {
    // Prevent multiple simultaneous loads
    if (!state.hasMore || state.isLoading || state.isLoadingMore) {
      debugPrint('⏸️ HomeBloc: Skipping load more - hasMore: ${state.hasMore}, isLoading: ${state.isLoading}, isLoadingMore: ${state.isLoadingMore}');
      return;
    }

    debugPrint('📄 HomeBloc: Loading more todos - current skip: $_currentSkip');
    emit(state.copyWith(isLoadingMore: true));

    try {
      // Fetch next page from API
      final newTodos = await repository.fetchTodosFromApi(
        skip: _currentSkip,
        limit: TodoConstants.todoPageSize,
      );

      // Reload all todos from DB to get the complete list
      final allDbTodos = await repository.loadFromDb(
        limit: _currentSkip + newTodos.length + TodoConstants.todoPageSize, // Get all loaded + buffer
        offset: 0,
      );

      debugPrint('✅ HomeBloc: Loaded ${newTodos.length} more todos, total: ${allDbTodos.length}');

      emit(state.copyWith(
        todos: allDbTodos,
        hasMore: newTodos.length == TodoConstants.todoPageSize, // More available if we got a full page
        isLoadingMore: false,
      ));

      _currentSkip += newTodos.length;
    } on NetworkException catch (e) {
      debugPrint('❌ HomeBloc: Network error loading more: ${e.message}');
      AppUtils.showToast(null, message: e.message);
      emit(state.copyWith(isLoadingMore: false));
    } on ApiException catch (e) {
      debugPrint('❌ HomeBloc: API error loading more: ${e.message}');
      AppUtils.showToast(null, message: e.message);
      emit(state.copyWith(isLoadingMore: false));
    } catch (e) {
      debugPrint('❌ HomeBloc: Error loading more todos: $e');
      AppUtils.showToast(null, message: 'Failed to load more todos. Please try again.');
      emit(state.copyWith(isLoadingMore: false));
    }
  }

  /// Refresh todos - clears DB and fetches fresh data from API
  Future<void> _onRefreshTodos(
    RefreshTodos event,
    Emitter<HomeState> emit,
  ) async {
    debugPrint('🔄 HomeBloc: Refreshing todos');
    emit(state.copyWith(isLoading: true));
    _currentSkip = 0;
    
    try {
      // Clear DB and fetch fresh data from API
      await repository.refresh();
      
      // Reload from DB to get the fresh data
      final dbTodos = await repository.loadFromDb(
        limit: TodoConstants.todoPageSize,
        offset: 0,
      );
      
      debugPrint('✅ HomeBloc: Refresh completed - loaded ${dbTodos.length} todos');
      
      emit(state.copyWith(
        todos: dbTodos,
        isLoading: false,
        hasMore: dbTodos.length == TodoConstants.todoPageSize,
        hasTriedApiAndFailed: false,
      ));
      
      _currentSkip = dbTodos.length;
    } on NetworkException catch (e) {
      debugPrint('❌ HomeBloc: Network error refreshing: ${e.message}');
      AppUtils.showToast(null, message: e.message);
      
      // Try to load existing data from DB if refresh failed
      final dbTodos = await repository.loadFromDb(
        limit: TodoConstants.todoPageSize,
        offset: 0,
      );
      
      emit(state.copyWith(
        todos: dbTodos,
        isLoading: false,
        hasTriedApiAndFailed: dbTodos.isEmpty,
      ));
      
      _currentSkip = dbTodos.length;
    } on ApiException catch (e) {
      debugPrint('❌ HomeBloc: API error refreshing: ${e.message}');
      AppUtils.showToast(null, message: e.message);
      
      // Try to load existing data from DB if refresh failed
      final dbTodos = await repository.loadFromDb(
        limit: TodoConstants.todoPageSize,
        offset: 0,
      );
      
      emit(state.copyWith(
        todos: dbTodos,
        isLoading: false,
        hasTriedApiAndFailed: dbTodos.isEmpty,
      ));
      
      _currentSkip = dbTodos.length;
    } catch (e) {
      debugPrint('❌ HomeBloc: Error refreshing todos: $e');
      AppUtils.showToast(null, message: 'Failed to refresh todos. Please try again.');
      
      // Try to load existing data from DB if refresh failed
      final dbTodos = await repository.loadFromDb(
        limit: TodoConstants.todoPageSize,
        offset: 0,
      );
      
      emit(state.copyWith(
        todos: dbTodos,
        isLoading: false,
        hasTriedApiAndFailed: dbTodos.isEmpty,
      ));
      
      _currentSkip = dbTodos.length;
    }
  }

  /// Toggle todo completed status - updates both state and DB
  Future<void> _onToggleTodo(
    ToggleTodo event,
    Emitter<HomeState> emit,
  ) async {
    final todo = state.todos.firstWhere((t) => t.id == event.id);
    final newCompleted = !todo.completed;
    
    // Update DB
    await repository.toggleCompleted(event.id, newCompleted);
    
    // Update state
    final updatedTodos = state.todos.map((t) {
      if (t.id == event.id) {
        return t.copyWith(completed: newCompleted);
      }
      return t;
    }).toList();

    emit(state.copyWith(todos: updatedTodos));
  }

  /// Delete todo - updates both state and DB
  Future<void> _onDeleteTodo(
    DeleteTodo event,
    Emitter<HomeState> emit,
  ) async {
    // Delete from DB
    await repository.deleteTodo(event.id);
    
    // Update state
    final updatedTodos = state.todos
        .where((todo) => todo.id != event.id)
        .toList();

    emit(state.copyWith(todos: updatedTodos));
  }

  Future<void> _onToggleFavorite(
    ToggleFavorite event,
    Emitter<HomeState> emit,
  ) async {
    final todo = state.todos.firstWhere((t) => t.id == event.id);
    await repository.toggleFavorite(event.id, !todo.isFavorite);

    final updatedTodos = state.todos.map((todo) {
      if (todo.id == event.id) {
        return todo.copyWith(isFavorite: !todo.isFavorite);
      }
      return todo;
    }).toList();

    emit(state.copyWith(todos: updatedTodos));
  }

  /// Clear all todos from local database
  Future<void> _onClearTodos(
    ClearTodosEvent event,
    Emitter<HomeState> emit,
  ) async {
    debugPrint('🧹 HomeBloc: Clearing all todos from local database');
    try {
      await repository.local.clearTodos();
      debugPrint('✅ HomeBloc: Todos cleared successfully');
      
      // Reset state to empty
      emit(state.copyWith(
        todos: [],
        hasMore: true,
        hasTriedApiAndFailed: false,
      ));
      _currentSkip = 0;
      
      debugPrint('✅ HomeBloc: State reset after clearing todos');
    } catch (e) {
      debugPrint('❌ HomeBloc: Error clearing todos: $e');
      // Don't emit error state, just log it
    }
  }
}

