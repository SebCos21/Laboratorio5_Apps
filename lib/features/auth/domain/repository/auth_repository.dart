import '../entities/auth_user.dart';

/// Contrato del lado izquierdo del mapa: la autenticación.
///
/// El dominio no sabe que existe Supabase; solo pide crear la cuenta, iniciar
/// sesión o cerrarla.
abstract class AuthRepository {
  /// Crea la cuenta en Auth y devuelve el usuario con su `id`.
  Future<AuthUser> signUp({required String email, required String password});

  /// Inicia sesión y devuelve el usuario con su `id`.
  Future<AuthUser> signIn({required String email, required String password});

  /// Cierra la sesión abierta en Auth.
  Future<void> signOut();
}
