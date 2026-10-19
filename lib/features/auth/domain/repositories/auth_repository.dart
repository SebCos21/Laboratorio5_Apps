import '../entities/auth_user.dart';

/// Contrato del destino "Supabase Auth".
///
/// Solo maneja correo y contraseña; el perfil vive en `ProfileRepository`.
abstract interface class AuthRepository {
  Future<AuthUser> signIn({required String email, required String password});

  Future<AuthUser> signUp({required String email, required String password});

  Future<void> signOut();

  Future<AuthUser?> currentUser();

  /// Emite el usuario cuando Supabase restaura, crea o cierra una sesión.
  Stream<AuthUser?> get authStateChanges;
}
