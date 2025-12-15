import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:to_do_app/core/components/background_screen.dart';
import 'package:to_do_app/core/constants/icon_class.dart';
import 'package:to_do_app/core/utils/app_utils.dart';
import 'package:to_do_app/features/auth/presentation/saved_accounts_screen.dart';
import 'package:to_do_app/features/splash/bloc/splash_bloc.dart';
import 'package:to_do_app/features/splash/bloc/splash_event.dart';
import 'package:to_do_app/features/splash/bloc/splash_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scale = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
    
    // Trigger splash bloc event
    context.read<SplashBloc>().add(SplashStarted());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashBloc, SplashState>(
      listener: (context, state) {
        debugPrint('SplashScreen: Received state: ${state.runtimeType}');
        if (state is SplashAuthenticated) {
          debugPrint('SplashScreen: Navigating to Home');
          Navigator.pushReplacementNamed(context, AppUtils.homeRoute);
        } else if (state is SplashUnauthenticated) {
          debugPrint('SplashScreen: Navigating to Login');
          Navigator.pushReplacementNamed(context, AppUtils.loginRoute);
        } else if (state is SplashShowSavedAccounts) {
          debugPrint('SplashScreen: Showing saved accounts screen');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SavedAccountsScreen(
                savedAccounts: state.savedAccounts,
              ),
            ),
          );
        }
      },
      child: Scaffold(
        body: BackgroundPattern(
          child: Center(
            child: FadeTransition(
              opacity: _fade,
              child: ScaleTransition(
                scale: _scale,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      IconClass.journeIcon,
                      width: 120,
                      height: 120,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Journé',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2C463D),
                      ),
                    ),
                    const SizedBox(height: 48),
                    const SpinKitFadingCircle(
                      color: Color(0xFF2C463D),
                      size: 22,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
