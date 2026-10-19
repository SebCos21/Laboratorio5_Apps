import '../entities/profile.dart';
import '../repositories/profile_repository.dart';

/// Crea la fila del perfil en la tabla `profiles`.
class CreateProfileUseCase {
  const CreateProfileUseCase(this._repository);

  final ProfileRepository _repository;

  Future<Profile> call({
    required String id,
    required String username,
    required String fullName,
  }) {
    return _repository.createProfile(
      id: id,
      username: username,
      fullName: fullName,
    );
  }
}
