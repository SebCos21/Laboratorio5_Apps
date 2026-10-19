import '../repository/auth_repository.dart';

/// Cierra la sesión en Auth antes de volver a `/login`.
///
/// Sin esto, la sesión sigue abierta en Supabase aunque la app muestre el
/// login.
class SignOutUseCase {
  final AuthRepository _auth;

  const SignOutUseCase(this._auth);

  Future<void> call() => _auth.signOut();
}
