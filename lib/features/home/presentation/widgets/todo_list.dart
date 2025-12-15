import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/core/constants/color_class.dart';
import '../bloc/home_state.dart';
import 'empty_state.dart';
import 'skeleton_loader.dart';
import 'todo_item.dart';

class TodoList extends StatelessWidget {
  final HomeState state;
  final ScrollController scrollController;
  final VoidCallback onRefresh;

  const TodoList({
    super.key,
    required this.state,
    required this.scrollController,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    // Show skeleton loader for initial load
    if (state.isLoading && state.todos.isEmpty) {
      return const SkeletonLoader();
    }
    
    // Show empty state
    if (state.todos.isEmpty) {
      return EmptyState(
        hasTriedApiAndFailed: state.hasTriedApiAndFailed,
        onRefresh: onRefresh, // Always provide refresh callback
      );
    }
    
    // Show todo list with pull to refresh
    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      color: ColorClass.kPrimaryColor,
      child: ListView.separated(
        controller: scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        itemCount: state.todos.length + (state.isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= state.todos.length) {
            // Show loading indicator for pagination
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CupertinoActivityIndicator(
                  radius: 16,
                  color: ColorClass.kPrimaryColor,
                ),
              ),
            );
          }
          final todo = state.todos[index];
          return TodoItem(todo: todo);
        },
        separatorBuilder: (context, index) => const SizedBox(height: 12),
      ),
    );
  }
}

