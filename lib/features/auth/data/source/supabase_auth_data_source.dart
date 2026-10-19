import 'package:supabase_flutter/supabase_flutter.dart' hide AuthUser;

import '../../domain/entities/auth_user.dart';
import '../../domain/errors/app_exception.dart';

/// El único archivo que usa el SDK de Auth (pasos 6 y Parte 2 del mapa).
///
/// Convierte la respuesta de Supabase en tu [AuthUser] y sus errores en
/// [AppException], para que de aquí hacia arriba nadie vea el SDK.
class SupabaseAuthDataSource {
  final SupabaseClient _client;

  SupabaseAuthDataSource(this._client);

  Future<AuthUser> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
      );

      // `response.user` puede ser null: se valida antes de usarlo.
      final user = response.user;
      if (user == null) {
        throw const AppException('No se pudo crear la cuenta.');
      }

      return AuthUser(id: user.id, email: user.email ?? email);
    } on AuthException catch (error) {
      throw AppException(error.message);
    }
  }

  Future<AuthUser> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user == null) {
        throw const AppException('No se pudo iniciar sesión.');
      }

      return AuthUser(id: user.id, email: user.email ?? email);
    } on AuthException catch (error) {
      throw AppException(error.message);
    }
  }

  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } on AuthException catch (error) {
      throw AppException(error.message);
    }
  }
}
