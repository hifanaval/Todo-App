import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/core/constants/color_class.dart';
import 'package:to_do_app/core/constants/textstyle_class.dart';
import 'package:to_do_app/core/utils/app_utils.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../../../../core/database/app_database.dart';

class TodoItem extends StatelessWidget {
  final TodoTableData todo;

  const TodoItem({
    super.key,
    required this.todo,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Dismissible(
          key: Key('todo_${todo.id}'),
          direction: DismissDirection.endToStart,
          background: Container(
            decoration: BoxDecoration(
              color: ColorClass.stateError,
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(
              Icons.delete_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          onDismissed: (direction) {
            context.read<HomeBloc>().add(DeleteTodo(todo.id));
          },
          child: Builder(
            builder: (context) {
              final theme = Theme.of(context);
              final isDark = theme.brightness == Brightness.dark;
              final cardColor = isDark ? ColorClass.darkCard : ColorClass.kCardColor;
              final shadowColor = isDark 
                  ? Colors.black.withOpacity(0.3)
                  : ColorClass.kDecorativeGreen.withOpacity(0.1);
              
              return Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: shadowColor,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      context.read<HomeBloc>().add(ToggleTodo(todo.id));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          _buildCheckbox(context, todo, isDark),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTodoContent(context, todo, isDark),
                          ),
                          _buildFavoriteButton(context, todo, isDark),
                          _buildDeleteButton(context, todo, isDark),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildCheckbox(BuildContext context, TodoTableData todo, bool isDark) {
    final primaryColor = isDark ? ColorClass.darkPrimary : ColorClass.kPrimaryColor;
    final borderColor = isDark ? ColorClass.darkBorder : ColorClass.neutral300;
    
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: todo.completed ? primaryColor : borderColor,
          width: 2,
        ),
        color: todo.completed ? primaryColor : Colors.transparent,
      ),
      child: todo.completed
          ? const Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: 16,
            )
          : null,
    );
  }

  Widget _buildTodoContent(BuildContext context, TodoTableData todo, bool isDark) {
    final textLightColor = isDark ? ColorClass.darkMutedForeground : ColorClass.kTextLight;
    final textColor = todo.completed
        ? (isDark ? ColorClass.darkMutedForeground : ColorClass.kTextSecondary)
        : (isDark ? ColorClass.darkForeground : ColorClass.kTextColor);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Todo #${todo.id}',
          style: TextStyleClass.primaryFont500(12, textLightColor),
        ),
        const SizedBox(height: 4),
        Text(
          todo.title,
          style: TextStyleClass.primaryFont400(16, textColor).copyWith(
            decoration: todo.completed ? TextDecoration.lineThrough : null,
            decorationColor: isDark ? ColorClass.darkMutedForeground : ColorClass.kTextSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildFavoriteButton(BuildContext context, TodoTableData todo, bool isDark) {
    return IconButton(
      onPressed: () {
        context.read<HomeBloc>().add(ToggleFavorite(todo.id));
      },
      icon: Icon(
        todo.isFavorite
            ? Icons.favorite_rounded
            : Icons.favorite_border_rounded,
        color: todo.isFavorite
            ? (isDark ? ColorClass.darkFavorite : ColorClass.stateError)
            : (isDark ? ColorClass.darkMutedForeground : ColorClass.kTextLight),
        size: 20,
      ),
      tooltip: todo.isFavorite ? 'Remove from favorites' : 'Add to favorites',
    );
  }

  Widget _buildDeleteButton(BuildContext context, TodoTableData todo, bool isDark) {
    final deleteIconColor = isDark ? ColorClass.darkMutedForeground : ColorClass.kTextLight;
    
    return IconButton(
      onPressed: () async {
        final shouldDelete = await AppUtils.showDeleteConfirmation(
          context: context,
          itemName: todo.title,
        );
        if (shouldDelete && context.mounted) {
          context.read<HomeBloc>().add(DeleteTodo(todo.id));
        }
      },
      icon: Icon(
        Icons.delete_outline_rounded,
        color: deleteIconColor,
        size: 20,
      ),
      tooltip: 'Delete',
    );
  }
}

