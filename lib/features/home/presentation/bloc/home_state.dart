import '../../../../core/database/app_database.dart';

class HomeState {
  final List<TodoTableData> todos;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;

  HomeState({
    required this.todos,
    required this.isLoading,
    this.isLoadingMore = false,
    required this.hasMore,
  });

  HomeState copyWith({
    List<TodoTableData>? todos,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
  }) {
    return HomeState(
      todos: todos ?? this.todos,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

