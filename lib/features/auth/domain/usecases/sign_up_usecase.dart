import '../entities/auth_user.dart';
import '../entities/profile.dart';
import '../repository/auth_repository.dart';
import '../repository/profile_repository.dart';

/// Registro de usuario: un formulario, dos destinos.
///
/// Es la única pieza que conoce los dos contratos y la que decide el orden:
/// primero la cuenta y después el perfil, con el `id` que devolvió Auth.
class SignUpUseCase {
  final AuthRepository _auth;
  final ProfileRepository _profiles;

  const SignUpUseCase(this._auth, this._profiles);

  Future<Profile> call({
    required String username,
    required String fullName,
    required String email,
    required String password,
  }) async {
    // 1º Auth: crea la cuenta y devuelve el id.
    final AuthUser user = await _auth.signUp(email: email, password: password);

    // 2º profiles: arma la entidad con ese id.
    final profile = Profile(
      id: user.id,
      username: username,
      fullName: fullName,
    );

    await _profiles.createProfile(profile);

    return profile;
  }
}
