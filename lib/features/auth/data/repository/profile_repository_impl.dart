import '../../domain/entities/profile.dart';
import '../../domain/repository/profile_repository.dart';
import '../source/supabase_profile_data_source.dart';

/// Implementa el contrato del perfil con el data source de Supabase (paso 7).
class ProfileRepositoryImpl implements ProfileRepository {
  final SupabaseProfileDataSource dataSource;

  const ProfileRepositoryImpl(this.dataSource);

  @override
  Future<void> createProfile(Profile profile) {
    return dataSource.createProfile(profile);
  }
}
