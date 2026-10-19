import 'package:laboratorio5_apps/features/auth/domain/entities/auth_user.dart';
import 'package:laboratorio5_apps/features/auth/domain/entities/profile.dart';
import 'package:laboratorio5_apps/features/auth/domain/repository/auth_repository.dart';
import 'package:laboratorio5_apps/features/auth/domain/repository/profile_repository.dart';

/// Doble de Auth: no toca Supabase.
class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({this.error});

  final Object? error;
  int calls = 0;

  @override
  Future<AuthUser> signUp({
    required String email,
    required String password,
  }) async {
    calls++;
    if (error != null) throw error!;
    return AuthUser(id: 'user-1', email: email);
  }
}

/// Doble de profiles: guarda los perfiles que recibe para verificarlos.
class FakeProfileRepository implements ProfileRepository {
  final List<Profile> received = [];

  int get calls => received.length;

  @override
  Future<void> createProfile(Profile profile) async {
    received.add(profile);
  }
}
