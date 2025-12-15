import '../../../../core/database/app_database.dart';

class HomeState {
  final List<TodoTableData> todos;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final bool hasTriedApiAndFailed; // Track if API was called and failed

  HomeState({
    required this.todos,
    required this.isLoading,
    this.isLoadingMore = false,
    required this.hasMore,
    this.hasTriedApiAndFailed = false,
  });

  HomeState copyWith({
    List<TodoTableData>? todos,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    bool? hasTriedApiAndFailed,
  }) {
    return HomeState(
      todos: todos ?? this.todos,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      hasTriedApiAndFailed: hasTriedApiAndFailed ?? this.hasTriedApiAndFailed,
    );
  }
}

