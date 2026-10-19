import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/profile.dart';
import '../../domain/errors/app_exception.dart';

/// El único archivo que escribe y lee tu tabla `profiles` (paso 7 y Parte 2).
///
/// En Dart el campo se llama `fullName`; en la tabla, la columna es
/// `full_name`. Este archivo es el único que conoce esa diferencia y el que
/// traduce los errores de Supabase a [AppException].
class SupabaseProfileDataSource {
  final SupabaseClient _client;

  SupabaseProfileDataSource(this._client);

  Future<void> createProfile(Profile profile) async {
    try {
      await _client.from('profiles').insert({
        'id': profile.id,
        'username': profile.username,
        'full_name': profile.fullName,
      });
    } on PostgrestException catch (error) {
      throw AppException(_friendlyMessage(error));
    }
  }

  Future<Profile> getProfile(String id) async {
    try {
      final row = await _client.from('profiles').select().eq('id', id).single();

      return Profile(
        id: row['id'] as String,
        username: row['username'] as String,
        fullName: row['full_name'] as String,
      );
    } on PostgrestException catch (error) {
      throw AppException(_friendlyMessage(error));
    }
  }

  /// Traduce los errores más frecuentes de PostgREST a algo mostrable.
  String _friendlyMessage(PostgrestException error) {
    switch (error.code) {
      case '42501':
        return 'Sin permiso para usar la tabla profiles. Revisa el grant y '
            'las policies en Supabase.';
      case '42P01':
        return 'No existe la tabla profiles en Supabase.';
      case '23502':
        return 'Falta un campo obligatorio en profiles. Revisa las columnas '
            'de la tabla.';
      case '23503':
        return 'No se encontró la cuenta de Auth asociada a este perfil.';
      case 'PGRST116':
        return 'No se encontró el perfil de esta cuenta.';
      default:
        return error.message;
    }
  }
}
