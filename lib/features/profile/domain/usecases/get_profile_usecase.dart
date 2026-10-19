import '../entities/profile.dart';
import '../repositories/profile_repository.dart';

/// Lee el perfil del usuario autenticado.
class GetProfileUseCase {
  const GetProfileUseCase(this._repository);

  final ProfileRepository _repository;

  Future<Profile?> call(String id) => _repository.getProfile(id);
}
