import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/core/constants/color_class.dart';
import 'package:to_do_app/core/constants/textstyle_class.dart';
import 'package:to_do_app/features/settings/presentation/pages/settings_screen.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_state.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;
        final textColor = isDark ? ColorClass.darkForeground : ColorClass.kTextColor;
        final textSecondaryColor = isDark ? ColorClass.darkMutedForeground : ColorClass.kTextSecondary;
        final primaryColor = isDark ? ColorClass.darkPrimary : ColorClass.kPrimaryColor;
        
        return Container(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Builder(
                    builder: (context) => IconButton(
                      onPressed: () => Scaffold.of(context).openDrawer(),
                      icon: Icon(
                        Icons.menu,
                        color: textColor,
                        size: 24,
                      ),
                      tooltip: 'Menu',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'My Todos',
                        style: TextStyleClass.primaryFont700(28, textColor),
                      ),
                      const SizedBox(height: 4),
                      BlocBuilder<HomeBloc, HomeState>(
                        builder: (context, state) {
                          final remaining = state.todos.where((t) => !t.completed).length;
                          return Text(
                            '$remaining tasks remaining',
                            style: TextStyleClass.primaryFont400(14, textSecondaryColor),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ),
                  );
                },
                icon: Icon(
                  Icons.settings_rounded,
                  color: primaryColor,
                  size: 24,
                ),
                tooltip: 'Settings',
              ),
            ],
          ),
        );
      },
    );
  }
}

