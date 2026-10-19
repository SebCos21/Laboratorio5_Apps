import '../models/profile_model.dart';

/// Acceso remoto a la tabla `profiles`.
abstract interface class ProfileDataSource {
  Future<ProfileModel> createProfile({
    required String id,
    required String username,
    required String fullName,
  });

  Future<ProfileModel?> getProfile(String id);
}

/// Implementación pendiente de completar con las imágenes de la guía.
///
/// Llamadas que irán aquí:
/// - `Supabase.instance.client.from('profiles').insert({...}).select().single()`
/// - `Supabase.instance.client.from('profiles').select().eq('id', id).maybeSingle()`
class SupabaseProfileDataSource implements ProfileDataSource {
  const SupabaseProfileDataSource();

  @override
  Future<ProfileModel> createProfile({
    required String id,
    required String username,
    required String fullName,
  }) {
    throw UnimplementedError(
      'SupabaseProfileDataSource.createProfile pendiente (guía).',
    );
  }

  @override
  Future<ProfileModel?> getProfile(String id) {
    throw UnimplementedError(
      'SupabaseProfileDataSource.getProfile pendiente (guía).',
    );
  }
}
