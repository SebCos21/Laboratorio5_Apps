import '../../../profile/domain/repositories/profile_repository.dart';
import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

/// Registro de usuario: un formulario, dos destinos.
///
/// 1. Crea la cuenta en Supabase Auth (correo y contraseña).
/// 2. Usa el `id` devuelto por Auth para guardar el perfil en `profiles`.
///
/// Es el único caso de uso que conoce ambos repositorios.
class SignUpUseCase {
  const SignUpUseCase(this._authRepository, this._profileRepository);

  final AuthRepository _authRepository;
  final ProfileRepository _profileRepository;

  Future<AuthUser> call({
    required String email,
    required String password,
    required String username,
    required String fullName,
  }) async {
    final user = await _authRepository.signUp(
      email: email,
      password: password,
    );

    await _profileRepository.createProfile(
      id: user.id,
      username: username,
      fullName: fullName,
    );

    return user;
  }
}
