import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/core/components/background_screen.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../widgets/home_drawer.dart';
import '../widgets/home_header.dart';
import '../widgets/todo_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    debugPrint('HomePage: initState - Loading initial todos');
    // Load initial data - shows DB data if available, fetches from API if empty
    context.read<HomeBloc>().add(LoadInitialTodos());
    
    // Pagination listener
    _scrollController.addListener(() {
      if (_scrollController.hasClients &&
          _scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200) {
        // Fetch more when near bottom
        context.read<HomeBloc>().add(LoadMoreTodos());
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const HomeDrawer(),
      body: BackgroundPattern(
        child: SafeArea(
          child: Column(
            children: [
              // Header
              const HomeHeader(),
              
              // Todo List
              Expanded(
                child: BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    return TodoList(
                      state: state,
                      scrollController: _scrollController,
                      onRefresh: () {
                        context.read<HomeBloc>().add(RefreshTodos());
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
