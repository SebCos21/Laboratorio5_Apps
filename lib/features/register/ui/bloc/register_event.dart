/// Eventos que recibe el RegisterBloc.
abstract class RegisterEvent {
  const RegisterEvent();
}

/// El usuario envió el formulario de registro.
class RegisterSubmitted extends RegisterEvent {
  final String username;
  final String fullName;
  final String email;
  final String password;

  const RegisterSubmitted({
    required this.username,
    required this.fullName,
    required this.email,
    required this.password,
  });
}
