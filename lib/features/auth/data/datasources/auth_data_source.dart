import '../../domain/entities/auth_user.dart';

/// Acceso remoto a Supabase Auth.
abstract interface class AuthDataSource {
  Future<AuthUser> signIn({required String email, required String password});

  Future<AuthUser> signUp({required String email, required String password});

  Future<void> signOut();

  Future<AuthUser?> currentUser();

  Stream<AuthUser?> get authStateChanges;
}

/// Implementación pendiente de completar con las imágenes de la guía.
///
/// Llamadas que irán aquí:
/// - `Supabase.instance.client.auth.signInWithPassword(...)`
/// - `Supabase.instance.client.auth.signUp(...)`
/// - `Supabase.instance.client.auth.signOut()`
/// - `Supabase.instance.client.auth.currentUser` y `onAuthStateChange`
class SupabaseAuthDataSource implements AuthDataSource {
  const SupabaseAuthDataSource();

  @override
  Future<AuthUser> signIn({required String email, required String password}) {
    throw UnimplementedError('SupabaseAuthDataSource.signIn pendiente (guía).');
  }

  @override
  Future<AuthUser> signUp({required String email, required String password}) {
    throw UnimplementedError('SupabaseAuthDataSource.signUp pendiente (guía).');
  }

  @override
  Future<void> signOut() {
    throw UnimplementedError('SupabaseAuthDataSource.signOut pendiente (guía).');
  }

  @override
  Future<AuthUser?> currentUser() {
    throw UnimplementedError(
      'SupabaseAuthDataSource.currentUser pendiente (guía).',
    );
  }

  @override
  Stream<AuthUser?> get authStateChanges {
    throw UnimplementedError(
      'SupabaseAuthDataSource.authStateChanges pendiente (guía).',
    );
  }
}
