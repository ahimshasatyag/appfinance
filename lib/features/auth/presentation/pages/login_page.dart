import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../../shared/theme/app_theme.dart';
import '../widgets/widgets.dart';
import 'register_page.dart';
import 'forgot_password_page.dart';
import '../../../../features/main_navigation/presentation/pages/main_navigation_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    final email = _emailController.text;
    final password = _passwordController.text;

    // Trigger event login ke BLoC
    context.read<AuthBloc>().add(LoginEvent(email: email, password: password));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            CustomDialog.showSuccess(
              context,
              title: 'Login Berhasil',
              message: 'Selamat datang, ${state.user.name}!',
              onConfirm: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MainNavigationPage()),
                );
              },
            );
          } else if (state is AuthError) {
            CustomDialog.showError(
              context,
              title: 'Login Gagal',
              message: state.message,
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            bottom: false,
            child: Column(
              children: [
                const SizedBox(
                  height: 100,
                ), // Memberikan ruang teal yang lebih besar di atas
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(
                        left: 32.0,
                        right: 32.0,
                        top: 60.0, // Memberikan jarak atas lebih dalam agar tidak terlalu nempel
                        bottom: 40.0,
                      ),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 500),
                          child: Column(
                            children: [
                              const Text(
                                'Login Account',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2B3A4A),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Notes Your Money',
                                style: TextStyle(fontSize: 14, color: Colors.grey),
                              ),

                              const SizedBox(height: 40),

                              // Logo / Image
                              Image.asset(
                                'assets/images/finance.jpg',
                                height: 120,
                                fit: BoxFit.contain,
                              ),

                              const SizedBox(height: 50),

                              // Form Content
                              AuthTextField(
                                controller: _emailController,
                                labelText: 'Email/ Phone number',
                                hintText: 'Example@gmail.com',
                              ),
                              const SizedBox(height: 20),
                              AuthTextField(
                                controller: _passwordController,
                                labelText: 'Password',
                                hintText: '********',
                                obscureText: true,
                              ),
                              const SizedBox(height: 12),
                              Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
                                    );
                                  },
                                  child: const Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      color: AppTheme.primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 40),

                              // Login Button
                              CustomButton(
                                text: 'Sign in',
                                height: 55,
                                isLoading: state is AuthLoading,
                                onPressed: _onLoginPressed,
                              ),

                              const SizedBox(height: 30),

                              // Footer text
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Don't have an account ? ",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const RegisterPage()),
                                      );
                                    },
                                    child: const Text(
                                      "Sign up",
                                      style: TextStyle(
                                        color: AppTheme.secondaryColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
