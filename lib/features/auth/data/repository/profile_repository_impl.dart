import '../../domain/entities/profile.dart';
import '../../domain/repository/profile_repository.dart';
import '../source/supabase_profile_data_source.dart';

/// Cumple el contrato del perfil igual que `AuthRepositoryImpl`: recibe el
/// data source por constructor y delega en él (paso 7).
class ProfileRepositoryImpl implements ProfileRepository {
  final SupabaseProfileDataSource _dataSource;

  ProfileRepositoryImpl(this._dataSource);

  @override
  Future<void> createProfile(Profile profile) {
    return _dataSource.createProfile(profile);
  }
}
