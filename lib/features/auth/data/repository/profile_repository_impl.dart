import '../../domain/entities/profile.dart';
import '../../domain/repository/profile_repository.dart';
import '../source/supabase_profile_data_source.dart';

/// Implementa el contrato del perfil con el data source de Supabase (paso 7).
class ProfileRepositoryImpl implements ProfileRepository {
  final SupabaseProfileDataSource dataSource;

  const ProfileRepositoryImpl(this.dataSource);

  @override
  Future<Profile> createProfile({
    required String id,
    required String username,
    required String fullName,
    required String email,
  }) {
    return dataSource.createProfile(
      id: id,
      username: username,
      fullName: fullName,
      email: email,
    );
  }
}
