import '../../domain/entities/auth_user.dart';
import '../../domain/repository/auth_repository.dart';
import '../source/supabase_auth_data_source.dart';

/// Implementa el contrato de Auth con el data source de Supabase (paso 6).
class AuthRepositoryImpl implements AuthRepository {
  final SupabaseAuthDataSource dataSource;

  const AuthRepositoryImpl(this.dataSource);

  @override
  Future<AuthUser> signUp({
    required String email,
    required String password,
  }) {
    return dataSource.signUp(email: email, password: password);
  }
}
