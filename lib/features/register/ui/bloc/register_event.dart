/// Eventos que recibe el RegisterBloc.
abstract class RegisterEvent {
  const RegisterEvent();
}

/// El usuario envió el formulario de registro.
class OnRegisterSubmittedEvent extends RegisterEvent {
  final String fullName;
  final String username;
  final String email;
  final String password;

  const OnRegisterSubmittedEvent({
    required this.fullName,
    required this.username,
    required this.email,
    required this.password,
  });
}
