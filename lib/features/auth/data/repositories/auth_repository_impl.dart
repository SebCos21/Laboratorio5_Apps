import '../../../../core/errors/error_mapper.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_data_source.dart';

/// Implementación del repositorio de Auth.
///
/// Delega en el data source y traduce cualquier excepción a un `Failure`.
class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._dataSource);

  final AuthDataSource _dataSource;

  @override
  Future<AuthUser> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await _dataSource.signIn(email: email, password: password);
    } catch (error) {
      throw mapErrorToFailure(error);
    }
  }

  @override
  Future<AuthUser> signUp({
    required String email,
    required String password,
  }) async {
    try {
      return await _dataSource.signUp(email: email, password: password);
    } catch (error) {
      throw mapErrorToFailure(error);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _dataSource.signOut();
    } catch (error) {
      throw mapErrorToFailure(error);
    }
  }

  @override
  Future<AuthUser?> currentUser() async {
    try {
      return await _dataSource.currentUser();
    } catch (error) {
      throw mapErrorToFailure(error);
    }
  }

  @override
  Stream<AuthUser?> get authStateChanges => _dataSource.authStateChanges;
}
