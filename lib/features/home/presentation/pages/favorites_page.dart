import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/core/components/background_screen.dart';
import 'package:to_do_app/core/constants/color_class.dart';
import 'package:to_do_app/core/constants/textstyle_class.dart';
import 'package:to_do_app/features/home/presentation/bloc/home_bloc.dart';
import 'package:to_do_app/features/home/presentation/bloc/home_event.dart';
import '../../../../core/database/app_database.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<TodoTableData> _favorites = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() => _isLoading = true);
    // Access repository through HomeBloc
    final homeBloc = context.read<HomeBloc>();
    final repository = (homeBloc as dynamic).repository;
    final favorites = await repository.getFavoriteTodos();
    setState(() {
      _favorites = favorites;
      _isLoading = false;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reload favorites when returning to this screen
    _loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundPattern(
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(),
              
              // Favorites List
              Expanded(
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: ColorClass.kPrimaryColor,
                        ),
                      )
                    : _favorites.isEmpty
                        ? _buildEmptyState()
                        : _buildFavoritesList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_rounded,
              color: ColorClass.kPrimaryColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Favorite Todos',
            style: TextStyleClass.primaryFont700(
              28,
              ColorClass.kTextColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: ColorClass.kDecorativeGreen.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.favorite_border_rounded,
              size: 64,
              color: ColorClass.kPrimaryColor.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No favorites yet!',
            style: TextStyleClass.primaryFont600(
              20,
              ColorClass.kTextColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add favorites from the home screen',
            style: TextStyleClass.primaryFont400(
              14,
              ColorClass.kTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesList() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      itemCount: _favorites.length,
      itemBuilder: (context, index) {
        final todo = _favorites[index];
        return _buildFavoriteItem(todo);
      },
      separatorBuilder: (context, index) => const SizedBox(height: 12),
    );
  }

  Widget _buildFavoriteItem(TodoTableData todo) {
    return Container(
      decoration: BoxDecoration(
        color: ColorClass.kCardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: ColorClass.kDecorativeGreen.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Favorite Icon
            Icon(
              Icons.favorite_rounded,
              color: ColorClass.stateError,
              size: 24,
            ),
            const SizedBox(width: 16),
            
            // Todo Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Todo #${todo.id}',
                    style: TextStyleClass.primaryFont500(
                      12,
                      ColorClass.kTextLight,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    todo.title,
                    style: TextStyleClass.primaryFont400(
                      16,
                      todo.completed
                          ? ColorClass.kTextSecondary
                          : ColorClass.kTextColor,
                    ).copyWith(
                      decoration: todo.completed
                          ? TextDecoration.lineThrough
                          : null,
                      decorationColor: ColorClass.kTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
            
            // Remove from favorites button
            IconButton(
              onPressed: () async {
                context.read<HomeBloc>().add(ToggleFavorite(todo.id));
                _loadFavorites();
              },
              icon: Icon(
                Icons.favorite_rounded,
                color: ColorClass.stateError,
                size: 20,
              ),
              tooltip: 'Remove from favorites',
            ),
          ],
        ),
      ),
    );
  }
}

