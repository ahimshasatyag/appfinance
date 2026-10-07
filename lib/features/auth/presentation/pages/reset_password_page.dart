import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/widgets/widgets.dart';
import '../../../../shared/theme/app_theme.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/widgets.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onSavePressed() {
    context.read<AuthBloc>().add(ResetPasswordEvent(
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is ResetPasswordSuccess) {
            CustomDialog.showSuccess(
              context,
              title: 'Berhasil',
              message: 'Password successfully reset!',
              onConfirm: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
            );
          } else if (state is AuthError) {
            CustomDialog.showError(context, title: 'Error', message: state.message);
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
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(left: 32.0, right: 32.0, top: 40.0, bottom: 40.0),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 500),
                          child: Column(
                            children: [
                              const Text(
                                'Reset Password',
                                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF2B3A4A)),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Create a new strong password',
                                style: TextStyle(fontSize: 14, color: Colors.grey),
                                textAlign: TextAlign.center,
                              ),
                              
                              const SizedBox(height: 40),
                              Image.asset(
                                'assets/icon/reset-password.png',
                                height: 120,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(height: 50),
                              
                              AuthTextField(
                                controller: _passwordController,
                                labelText: 'New Password',
                                hintText: '********',
                                obscureText: true,
                              ),
                              const SizedBox(height: 20),
                              AuthTextField(
                                controller: _confirmPasswordController,
                                labelText: 'Confirm Password',
                                hintText: '********',
                                obscureText: true,
                              ),
                              
                              const SizedBox(height: 40),
                              CustomButton(
                                text: 'Save Password',
                                height: 55,
                                isLoading: state is AuthLoading,
                                onPressed: _onSavePressed,
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
