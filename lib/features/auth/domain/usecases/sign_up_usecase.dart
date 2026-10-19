import '../entities/auth_user.dart';
import '../entities/profile.dart';
import '../repository/auth_repository.dart';
import '../repository/profile_repository.dart';

/// Registro de usuario: un formulario, dos destinos.
///
/// Es la única pieza que conoce las dos columnas del mapa:
///
/// 1. **Auth**: crea la cuenta con correo y contraseña y devuelve el `id`.
/// 2. **profiles**: guarda el perfil con ese `id`.
///
/// Devuelve el `Profile` porque es lo que la app necesita mostrar después.
class SignUpUseCase {
  final AuthRepository authRepository;
  final ProfileRepository profileRepository;

  const SignUpUseCase({
    required this.authRepository,
    required this.profileRepository,
  });

  Future<Profile> call({
    required String email,
    required String password,
    required String username,
    required String fullName,
  }) async {
    // 1º Auth.
    final AuthUser user = await authRepository.signUp(
      email: email,
      password: password,
    );

    // 2º profiles, con el id que devolvió Auth.
    return profileRepository.createProfile(
      id: user.id,
      username: username,
      fullName: fullName,
      email: email,
    );
  }
}
