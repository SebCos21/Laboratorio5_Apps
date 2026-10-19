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

/// Doble de profiles: guarda lo que recibe para poder verificarlo.
class FakeProfileRepository implements ProfileRepository {
  int calls = 0;
  String? lastId;
  String? lastUsername;
  String? lastFullName;
  String? lastEmail;

  @override
  Future<Profile> createProfile({
    required String id,
    required String username,
    required String fullName,
    required String email,
  }) async {
    calls++;
    lastId = id;
    lastUsername = username;
    lastFullName = fullName;
    lastEmail = email;
    return Profile(id: id, username: username, fullName: fullName, email: email);
  }
}
