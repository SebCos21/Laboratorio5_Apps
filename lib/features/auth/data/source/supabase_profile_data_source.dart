import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/profile.dart';

/// El único archivo que escribe en tu tabla `profiles` (paso 7 del mapa).
///
/// En Dart el campo se llama `fullName`; en la tabla, la columna es
/// `full_name`. Este archivo es el único que conoce esa diferencia.
class SupabaseProfileDataSource {
  final SupabaseClient _client;

  SupabaseProfileDataSource(this._client);

  Future<void> createProfile(Profile profile) async {
    await _client.from('profiles').insert({
      'id': profile.id,
      'username': profile.username,
      'full_name': profile.fullName,
      'email': profile.email,
    });
  }
}
