/// Eventos que recibe el LoginBloc.
abstract class LoginEvent {
  const LoginEvent();
}

/// El usuario envió el formulario de inicio de sesión.
class LoginSubmitted extends LoginEvent {
  final String email;
  final String password;

  const LoginSubmitted({required this.email, required this.password});
}
