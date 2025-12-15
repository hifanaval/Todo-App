import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';
import '../../data/repository/todo_repository.dart';
import '../../../../core/constants/todo_constants.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final TodoRepository repository;
  int page = 0;

  HomeBloc(this.repository)
      : super(HomeState(
          todos: [],
          isLoading: false,
          isLoadingMore: false,
          hasMore: true,
        )) {
    on<LoadInitialTodos>(_onLoadInitialTodos);
    on<LoadMoreTodos>(_onLoadMoreTodos);
    on<RefreshTodos>(_onRefreshTodos);
    on<ToggleTodo>(_onToggleTodo);
    on<DeleteTodo>(_onDeleteTodo);
    on<ToggleFavorite>(_onToggleFavorite);
  }

  Future<void> _onLoadInitialTodos(
    LoadInitialTodos event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final dbTodos = await repository.loadFromDb(
      limit: TodoConstants.todoPageSize,
      offset: 0,
    );

    if (dbTodos.isNotEmpty) {
      emit(state.copyWith(
        todos: dbTodos,
        isLoading: false,
      ));
    } else {
      final newTodos = await repository.fetchAndSave(
        page: 0,
        limit: TodoConstants.todoPageSize,
      );
      page = 1;
      final newDbTodos = await repository.loadFromDb(
        limit: TodoConstants.todoPageSize,
        offset: 0,
      );
      emit(state.copyWith(
        todos: newDbTodos,
        isLoading: false,
        hasMore: newTodos.length == TodoConstants.todoPageSize,
      ));
    }
  }

  Future<void> _onLoadMoreTodos(
    LoadMoreTodos event,
    Emitter<HomeState> emit,
  ) async {
    if (!state.hasMore || state.isLoading || state.isLoadingMore) return;

    emit(state.copyWith(isLoadingMore: true));

    final newTodos = await repository.fetchAndSave(
      page: page,
      limit: TodoConstants.todoPageSize,
    );

    final dbTodos = await repository.loadFromDb(
      limit: TodoConstants.todoPageSize,
      offset: state.todos.length,
    );

    final updatedTodos = [...state.todos, ...dbTodos];

    emit(state.copyWith(
      todos: updatedTodos,
      hasMore: newTodos.length == TodoConstants.todoPageSize,
      isLoadingMore: false,
    ));

    page++;
  }

  Future<void> _onRefreshTodos(
    RefreshTodos event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    page = 0;
    await repository.refresh();
    // Reload from page 1 (index 0)
    final newTodos = await repository.fetchAndSave(
      page: 0,
      limit: TodoConstants.todoPageSize,
    );
    page = 1;
    final dbTodos = await repository.loadFromDb(
      limit: TodoConstants.todoPageSize,
      offset: 0,
    );
    emit(state.copyWith(
      todos: dbTodos,
      isLoading: false,
      hasMore: newTodos.length == TodoConstants.todoPageSize,
    ));
  }

  void _onToggleTodo(
    ToggleTodo event,
    Emitter<HomeState> emit,
  ) {
    final updatedTodos = state.todos.map((todo) {
      if (todo.id == event.id) {
        return todo.copyWith(completed: !todo.completed);
      }
      return todo;
    }).toList();

    emit(state.copyWith(todos: updatedTodos));
  }

  void _onDeleteTodo(
    DeleteTodo event,
    Emitter<HomeState> emit,
  ) {
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
}

