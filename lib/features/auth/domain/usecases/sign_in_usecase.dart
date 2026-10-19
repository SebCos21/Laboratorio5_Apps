import '../entities/auth_user.dart';
import '../entities/profile.dart';
import '../repository/auth_repository.dart';
import '../repository/profile_repository.dart';

/// Inicio de sesión: también son dos pasos.
///
/// 1. **Auth**: valida correo y contraseña y devuelve el `AuthUser`.
/// 2. **profiles**: con ese `id`, trae el perfil guardado.
class SignInUseCase {
  final AuthRepository _auth;
  final ProfileRepository _profiles;

  const SignInUseCase(this._auth, this._profiles);

  Future<Profile> call({
    required String email,
    required String password,
  }) async {
    final AuthUser user = await _auth.signIn(email: email, password: password);

    return _profiles.getProfile(user.id);
  }
}
