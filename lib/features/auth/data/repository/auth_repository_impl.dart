import '../../domain/entities/auth_user.dart';
import '../../domain/repository/auth_repository.dart';
import '../source/supabase_auth_data_source.dart';

/// Cumple el contrato de Auth delegando en el data source (paso 6).
class AuthRepositoryImpl implements AuthRepository {
  final SupabaseAuthDataSource _dataSource;

  AuthRepositoryImpl(this._dataSource);

  @override
  Future<AuthUser> signUp({
    required String email,
    required String password,
  }) {
    return _dataSource.signUp(email: email, password: password);
  }
}
