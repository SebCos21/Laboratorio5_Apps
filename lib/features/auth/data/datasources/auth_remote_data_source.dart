import '../../domain/entities/auth_user.dart';

/// Acceso remoto a Supabase Auth.
abstract interface class AuthRemoteDataSource {
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
class SupabaseAuthRemoteDataSource implements AuthRemoteDataSource {
  const SupabaseAuthRemoteDataSource();

  @override
  Future<AuthUser> signIn({required String email, required String password}) {
    throw UnimplementedError(
      'AuthRemoteDataSource.signIn pendiente de la guía.',
    );
  }

  @override
  Future<AuthUser> signUp({required String email, required String password}) {
    throw UnimplementedError(
      'AuthRemoteDataSource.signUp pendiente de la guía.',
    );
  }

  @override
  Future<void> signOut() {
    throw UnimplementedError(
      'AuthRemoteDataSource.signOut pendiente de la guía.',
    );
  }

  @override
  Future<AuthUser?> currentUser() {
    throw UnimplementedError(
      'AuthRemoteDataSource.currentUser pendiente de la guía.',
    );
  }

  @override
  Stream<AuthUser?> get authStateChanges {
    throw UnimplementedError(
      'AuthRemoteDataSource.authStateChanges pendiente de la guía.',
    );
  }
}
