import '../../domain/entities/profile.dart';

/// Modelo de la tabla `profiles`.
///
/// Traduce entre el mapa de Supabase (snake_case) y la entidad de dominio.
class ProfileModel {
  const ProfileModel({
    required this.id,
    required this.username,
    required this.fullName,
    this.createdAt,
  });

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      id: map['id'] as String,
      username: map['username'] as String,
      fullName: map['full_name'] as String,
      createdAt: map['created_at'] as String?,
    );
  }

  final String id;
  final String username;
  final String fullName;
  final String? createdAt;

  /// Datos que se envían al insertar la fila.
  Map<String, dynamic> toMap() {
    return {'id': id, 'username': username, 'full_name': fullName};
  }

  Profile toEntity() {
    return Profile(
      id: id,
      username: username,
      fullName: fullName,
      createdAt: createdAt,
    );
  }
}
