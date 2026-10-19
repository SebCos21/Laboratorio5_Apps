import '../../../../core/errors/error_mapper.dart';
import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_data_source.dart';

/// Implementación del repositorio de perfiles.
class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(this._dataSource);

  final ProfileDataSource _dataSource;

  @override
  Future<Profile> createProfile({
    required String id,
    required String username,
    required String fullName,
  }) async {
    try {
      final model = await _dataSource.createProfile(
        id: id,
        username: username,
        fullName: fullName,
      );
      return model.toEntity();
    } catch (error) {
      throw mapErrorToFailure(error);
    }
  }

  @override
  Future<Profile?> getProfile(String id) async {
    try {
      final model = await _dataSource.getProfile(id);
      return model?.toEntity();
    } catch (error) {
      throw mapErrorToFailure(error);
    }
  }
}
