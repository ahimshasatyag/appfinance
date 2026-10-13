import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';
import '../bloc/auth_event.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../shared/theme/app_colors.dart';
import '../widgets/widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onRegisterPressed() {
    final email = _emailController.text;
    final phone = _phoneController.text;
    final password = _passwordController.text;

    context.read<AuthBloc>().add(RegisterEvent(
      email: email,
      phone: phone,
      password: password,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppTheme.primaryColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
            CustomDialog.showSuccess(
              context,
              title: 'Register Berhasil',
              message: 'Akun Anda telah dibuat!',
              onConfirm: () {
                Navigator.pop(context); // kembali ke halaman login
              },
            );
          } else if (state is AuthError) {
            CustomDialog.showError(
              context,
              title: 'Register Gagal',
              message: state.message,
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            bottom: false,
            child: Column(
              children: [
                const SizedBox(height: 20),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(
                        left: 32.0,
                        right: 32.0,
                        top: 40.0,
                        bottom: 40.0,
                      ),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 500),
                          child: Column(
                            children: [
                              Text(
                                'Sign up Account',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? AppColors.darkTextPrimary : const Color(0xFF2B3A4A),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Create a new account',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isDark ? Colors.grey.shade400 : Colors.grey,
                                ),
                              ),
                              
                              const SizedBox(height: 40),
                              
                              // Logo / Icon
                              Image.asset(
                                'assets/icon/online-registration.png',
                                height: 120,
                                fit: BoxFit.contain,
                              ),
                              
                              const SizedBox(height: 50),
                              
                              // Form Content
                              AuthTextField(
                                controller: _emailController,
                                labelText: 'Email',
                                hintText: 'Example@gmail.com',
                              ),
                              const SizedBox(height: 20),
                              AuthTextField(
                                controller: _phoneController,
                                labelText: 'Phone number',
                                hintText: '081234567890',
                              ),
                              const SizedBox(height: 20),
                              AuthTextField(
                                controller: _passwordController,
                                labelText: 'Password',
                                hintText: '********',
                                obscureText: true,
                              ),
                              
                              const SizedBox(height: 40),
                              
                              // Register Button
                              CustomButton(
                                text: 'Sign up',
                                height: 55,
                                isLoading: state is AuthLoading,
                                onPressed: _onRegisterPressed,
                              ),
                              
                              const SizedBox(height: 30),
                              
                              // Footer text
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Already have an account ? ",
                                    style: TextStyle(
                                      color: isDark ? Colors.grey.shade400 : Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      "Sign in",
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
