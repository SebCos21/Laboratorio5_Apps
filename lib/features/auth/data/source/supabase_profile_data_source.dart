import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/profile.dart';

/// Único lugar que escribe en tu tabla `profiles` (paso 7 del mapa).
class SupabaseProfileDataSource {
  const SupabaseProfileDataSource();

  /// Inserta la fila del perfil con el `id` que devolvió Auth.
  Future<Profile> createProfile({
    required String id,
    required String username,
    required String fullName,
    required String email,
  }) async {
    await Supabase.instance.client.from('profiles').insert({
      'id': id,
      'username': username,
      'full_name': fullName,
      'email': email,
    });

    return Profile(
      id: id,
      username: username,
      fullName: fullName,
      email: email,
    );
  }
}
