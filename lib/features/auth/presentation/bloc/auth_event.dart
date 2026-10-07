abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent({required this.email, required this.password});
}

class RegisterEvent extends AuthEvent {
  final String email;
  final String phone;
  final String password;

  RegisterEvent({required this.email, required this.phone, required this.password});
}

class ForgotPasswordEvent extends AuthEvent {
  final String email;

  ForgotPasswordEvent({required this.email});
}

class VerifyEmailEvent extends AuthEvent {
  final String code;

  VerifyEmailEvent({required this.code});
}

class ResetPasswordEvent extends AuthEvent {
  final String password;
  final String confirmPassword;

  ResetPasswordEvent({required this.password, required this.confirmPassword});
}
