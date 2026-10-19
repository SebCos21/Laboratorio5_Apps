import '../entities/profile.dart';

/// Contrato del destino "tabla profiles".
abstract interface class ProfileRepository {
  /// Guarda la fila del perfil usando el `id` que devolvió Supabase Auth.
  Future<Profile> createProfile({
    required String id,
    required String username,
    required String fullName,
  });

  Future<Profile?> getProfile(String id);
}
