import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/profile.dart';

/// Único lugar que escribe en tu tabla `profiles` (paso 7 del mapa).
class SupabaseProfileDataSource {
  const SupabaseProfileDataSource();

  /// Inserta la fila del perfil con el `id` que devolvió Auth.
  Future<void> createProfile(Profile profile) async {
    await Supabase.instance.client.from('profiles').insert({
      'id': profile.id,
      'username': profile.username,
      'full_name': profile.fullName,
      'email': profile.email,
    });
  }
}
