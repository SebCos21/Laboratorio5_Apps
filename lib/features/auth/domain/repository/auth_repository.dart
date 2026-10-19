import '../entities/auth_user.dart';

/// Contrato del lado izquierdo del mapa: la autenticación.
///
/// El dominio no sabe que existe Supabase; solo pide que se cree la cuenta.
abstract class AuthRepository {
  /// Crea la cuenta en Auth y devuelve el usuario con su `id`.
  Future<AuthUser> signUp({required String email, required String password});
}
