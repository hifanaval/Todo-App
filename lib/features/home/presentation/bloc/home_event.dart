abstract class HomeEvent {}

class LoadInitialTodos extends HomeEvent {}

class LoadMoreTodos extends HomeEvent {}

class RefreshTodos extends HomeEvent {}

class ToggleTodo extends HomeEvent {
  final int id;
  ToggleTodo(this.id);
}

class DeleteTodo extends HomeEvent {
  final int id;
  DeleteTodo(this.id);
}

class ToggleFavorite extends HomeEvent {
  final int id;
  ToggleFavorite(this.id);
}

