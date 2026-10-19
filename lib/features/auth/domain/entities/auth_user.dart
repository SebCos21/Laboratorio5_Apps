import 'package:equatable/equatable.dart';

/// Usuario autenticado que devuelve Supabase Auth.
///
/// No contiene la contraseña: la capa de dominio solo conserva lo que la app
/// necesita para identificar la sesión.
class AuthUser extends Equatable {
  const AuthUser({required this.id, required this.email});

  final String id;
  final String email;

  @override
  List<Object?> get props => [id, email];
}
