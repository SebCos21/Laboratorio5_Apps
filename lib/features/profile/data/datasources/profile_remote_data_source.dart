import '../models/profile_model.dart';

/// Acceso remoto a la tabla `profiles`.
abstract interface class ProfileRemoteDataSource {
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
class SupabaseProfileRemoteDataSource implements ProfileRemoteDataSource {
  const SupabaseProfileRemoteDataSource();

  @override
  Future<ProfileModel> createProfile({
    required String id,
    required String username,
    required String fullName,
  }) {
    throw UnimplementedError(
      'ProfileRemoteDataSource.createProfile pendiente de la guía.',
    );
  }

  @override
  Future<ProfileModel?> getProfile(String id) {
    throw UnimplementedError(
      'ProfileRemoteDataSource.getProfile pendiente de la guía.',
    );
  }
}
