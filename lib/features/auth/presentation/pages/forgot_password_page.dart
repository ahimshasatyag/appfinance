import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/widgets/widgets.dart';
import '../../../../shared/theme/app_theme.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/widgets.dart';
import 'email_verification_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onSendCodePressed() {
    context.read<AuthBloc>().add(ForgotPasswordEvent(email: _emailController.text));
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
          if (state is ForgotPasswordSuccess) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EmailVerificationPage()),
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
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(left: 32.0, right: 32.0, top: 40.0, bottom: 40.0),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 500),
                          child: Column(
                            children: [
                              const Text(
                                'Forgot Password',
                                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF2B3A4A)),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Enter your email to receive a code',
                                style: TextStyle(fontSize: 14, color: Colors.grey),
                                textAlign: TextAlign.center,
                              ),
                              
                              const SizedBox(height: 40),
                              Image.asset(
                                'assets/icon/forgot-password.png',
                                height: 120,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(height: 50),
                              
                              AuthTextField(
                                controller: _emailController,
                                labelText: 'Email',
                                hintText: 'Example@gmail.com',
                              ),
                              
                              const SizedBox(height: 40),
                              CustomButton(
                                text: 'Send Code',
                                height: 55,
                                isLoading: state is AuthLoading,
                                onPressed: _onSendCodePressed,
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
