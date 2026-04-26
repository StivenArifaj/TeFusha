abstract class AuthEvent {}

class LoginSubmitted extends AuthEvent {
  final String email;
  final String password;
  LoginSubmitted(this.email, this.password);
}

class RegisterSubmitted extends AuthEvent {
  final String fullName;
  final String email;
  final String password;
  final String role;
  RegisterSubmitted(this.fullName, this.email, this.password, this.role);
}

class LogoutRequested extends AuthEvent {}
