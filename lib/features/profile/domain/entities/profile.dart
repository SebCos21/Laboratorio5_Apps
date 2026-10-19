import 'package:equatable/equatable.dart';

/// Perfil público del usuario, guardado en la tabla `profiles`.
class Profile extends Equatable {
  const Profile({
    required this.id,
    required this.username,
    required this.fullName,
    this.createdAt,
  });

  /// Igual al `id` de la cuenta en Supabase Auth.
  final String id;
  final String username;
  final String fullName;
  final String? createdAt;

  @override
  List<Object?> get props => [id, username, fullName, createdAt];
}
