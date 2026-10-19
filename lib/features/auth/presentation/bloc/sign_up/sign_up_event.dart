import 'package:equatable/equatable.dart';

sealed class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object?> get props => [];
}

/// El formulario de registro pasó la validación local.
///
/// La confirmación de contraseña no se envía: solo se compara en pantalla.
final class SignUpSubmitted extends SignUpEvent {
  const SignUpSubmitted({
    required this.username,
    required this.fullName,
    required this.email,
    required this.password,
  });

  final String username;
  final String fullName;
  final String email;
  final String password;

  @override
  List<Object?> get props => [username, fullName, email, password];
}
