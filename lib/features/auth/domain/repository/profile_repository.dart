import '../entities/profile.dart';

/// Contrato del lado derecho del mapa: el perfil en tu tabla `profiles`.
abstract class ProfileRepository {
  /// Guarda la fila del perfil usando el `id` que devolvió Auth.
  Future<Profile> createProfile({
    required String id,
    required String username,
    required String fullName,
    required String email,
  });
}
