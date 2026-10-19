import '../repositories/auth_repository.dart';

/// Cierra la sesión actual.
class SignOutUseCase {
  const SignOutUseCase(this._repository);

  final AuthRepository _repository;

  Future<void> call() => _repository.signOut();
}
