import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/profile.dart';

/// El único archivo que escribe y lee tu tabla `profiles` (paso 7 y Parte 2).
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

  Future<Profile> getProfile(String id) async {
    final row = await _client.from('profiles').select().eq('id', id).single();

    return Profile(
      id: row['id'] as String,
      username: row['username'] as String,
      fullName: row['full_name'] as String,
      email: row['email'] as String? ?? '',
    );
  }
}
