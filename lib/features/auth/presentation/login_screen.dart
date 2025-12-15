import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/core/components/background_screen.dart';
import 'package:to_do_app/core/components/textformfield_widget.dart';
import 'package:to_do_app/core/components/primary_button.dart';
import 'package:to_do_app/core/constants/color_class.dart';
import 'package:to_do_app/core/constants/icon_class.dart';
import 'package:to_do_app/core/constants/textstyle_class.dart';
import 'package:to_do_app/core/utils/app_utils.dart';
import 'package:to_do_app/features/auth/bloc/auth_bloc.dart';
import 'package:to_do_app/features/auth/bloc/auth_event.dart';
import 'package:to_do_app/features/auth/bloc/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  
  String? _emailError;
  String? _passwordError;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateEmail);
    _passwordController.addListener(_validatePassword);
  }

  @override
  void dispose() {
    _emailController.removeListener(_validateEmail);
    _passwordController.removeListener(_validatePassword);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateEmail() {
    final email = _emailController.text.trim();
    debugPrint('Validating email: $email');
    
    if (email.isEmpty) {
      setState(() {
        _emailError = 'Email is required';
      });
    } else if (!AppUtils.isValidEmail(email)) {
      setState(() {
        _emailError = 'Please enter a valid email address';
      });
    } else {
      setState(() {
        _emailError = null;
      });
    }
  }

  void _validatePassword() {
    final password = _passwordController.text;
    debugPrint('Validating password: ${password.length} characters');
    
    if (password.isEmpty) {
      setState(() {
        _passwordError = 'Password is required';
      });
    } else if (password.length < 6) {
      setState(() {
        _passwordError = 'Password must be at least 6 characters';
      });
    } else {
      setState(() {
        _passwordError = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        debugPrint('LoginScreen: Received state: ${state.runtimeType}');
        if (state is AuthAuthenticated) {
          debugPrint('LoginScreen: Login successful');
          AppUtils.showToast(context, message: 'Login successful');
          Navigator.pushReplacementNamed(context, AppUtils.homeRoute);
        } else if (state is AuthError) {
          debugPrint('LoginScreen: Login error: ${state.message}');
          AppUtils.showToast(context, message: state.message);
        }
      },
      child: Scaffold(
      body: BackgroundPattern(
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    IconClass.journeIcon,
                    width: 120,
                    height: 120,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Welcome Back!',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C463D),
                    ),
                  ),
                  const SizedBox(height: 32),

                  CustomTextField(
                    label: 'Email Address',
                    prefix: const Icon(Icons.email_outlined),
                    controller: _emailController,
                    type: TextFieldType.email,
                    validator: (value) => _emailError,
                  ),
                  if (_emailError != null)
                    Padding(
                      padding: const EdgeInsets.only( top: 4),
                      child: Text(
                        _emailError!,
                        style: TextStyleClass.primaryFont400(
                          12,
                          ColorClass.stateError,
                        ),
                      ),
                  ),
                  const SizedBox(height: 8),
                  CustomTextField(
                    label: 'Password',
                    prefix: const Icon(Icons.lock_outline),
                    controller: _passwordController,
                    type: TextFieldType.password,
                    validator: (value) => _passwordError,
                  ),
                  if (_passwordError != null)
                    Padding(
                      padding: const EdgeInsets.only( top: 4),
                      child: Text(
                        _passwordError!,
                        style: TextStyleClass.primaryFont400(
                          12,
                          ColorClass.stateError,
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (value) {
                          debugPrint('Remember me checkbox toggled: $value');
                          setState(() {
                            _rememberMe = value ?? false;
                          });
                        },
                        activeColor: ColorClass.kPrimaryColor,
                        checkColor: Colors.white,
                      ),
                      GestureDetector(
                        onTap: () {
                          debugPrint('Remember me label tapped');
                          setState(() {
                            _rememberMe = !_rememberMe;
                          });
                    },
                        child: Text(
                          'Remember Me',
                          style: TextStyleClass.primaryFont400(
                            14,
                            ColorClass.kTextSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  PrimaryButton(
                    text: 'LOG IN',
                    onPressed: () {
                      final email = _emailController.text.trim();
                      final password = _passwordController.text.trim();
                      
                      debugPrint('Login attempted - Email: $email, Remember me: $_rememberMe');
                      
                      // Trigger validation to show errors if fields are empty or invalid
                      _validateEmail();
                      _validatePassword();
                      
                      // Check if there are validation errors
                      if (_emailError != null || _passwordError != null) {
                        debugPrint('Form validation errors present');
                        return;
                      }
                      
                      // Dispatch login event to AuthBloc
                      context.read<AuthBloc>().add(LoginEvent(
                        email: email,
                        password: password,
                        rememberMe: _rememberMe,
                      ));
                    },
                  ),
                  const SizedBox(height: 16),

                  TextButton(
                    onPressed: () {
                      AppUtils.pushNamed(context, AppUtils.registrationRoute);
                    },
                    child: Text.rich(
                      TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(color: ColorClass.kTextSecondary),
                        children: const [
                          TextSpan(
                            text: 'Sign Up',
                            style: TextStyle(
                              color: ColorClass.kPrimaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
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
