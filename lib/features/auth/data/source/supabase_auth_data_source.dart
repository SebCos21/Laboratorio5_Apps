import 'package:supabase_flutter/supabase_flutter.dart' hide AuthUser;

import '../../domain/entities/auth_user.dart';

/// Único lugar que llama a Supabase Auth (paso 6 del mapa).
class SupabaseAuthDataSource {
  const SupabaseAuthDataSource();

  /// Crea la cuenta con correo y contraseña.
  ///
  /// Devuelve el usuario con su `id` para poder guardar el perfil.
  Future<AuthUser> signUp({
    required String email,
    required String password,
  }) async {
    final response = await Supabase.instance.client.auth.signUp(
      email: email,
      password: password,
    );

    final user = response.user;
    if (user == null) {
      throw const AuthException('No se pudo crear la cuenta.');
    }

    return AuthUser(id: user.id, email: user.email ?? email);
  }
}
