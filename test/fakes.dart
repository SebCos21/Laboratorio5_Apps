import 'package:laboratorio5_apps/features/auth/domain/entities/auth_user.dart';
import 'package:laboratorio5_apps/features/auth/domain/entities/profile.dart';
import 'package:laboratorio5_apps/features/auth/domain/repository/auth_repository.dart';
import 'package:laboratorio5_apps/features/auth/domain/repository/profile_repository.dart';

/// Doble de Auth: no toca Supabase.
class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({this.error, this.signInError});

  /// Error que lanza `signUp`.
  final Object? error;

  /// Error que lanza `signIn`.
  final Object? signInError;

  int calls = 0;
  int signInCalls = 0;
  int signOutCalls = 0;

  @override
  Future<AuthUser> signUp({
    required String email,
    required String password,
  }) async {
    calls++;
    if (error != null) throw error!;
    return AuthUser(id: 'user-1', email: email);
  }

  @override
  Future<AuthUser> signIn({
    required String email,
    required String password,
  }) async {
    signInCalls++;
    if (signInError != null) throw signInError!;
    return AuthUser(id: 'user-1', email: email);
  }

  @override
  Future<void> signOut() async {
    signOutCalls++;
  }
}

/// Doble de profiles: guarda los perfiles que recibe y devuelve uno fijo.
class FakeProfileRepository implements ProfileRepository {
  FakeProfileRepository({this.profile, this.getProfileError});

  /// Perfil que devuelve `getProfile` cuando no se indica otro.
  final Profile? profile;

  /// Error que lanza `getProfile`.
  final Object? getProfileError;

  final List<Profile> received = [];

  int get calls => received.length;
  int getProfileCalls = 0;

  @override
  Future<void> createProfile(Profile profile) async {
    received.add(profile);
  }

  @override
  Future<Profile> getProfile(String id) async {
    getProfileCalls++;
    if (getProfileError != null) throw getProfileError!;

    return profile ??
        Profile(
          id: id,
          username: 'ana',
          fullName: 'Ana Gómez',
          email: 'ana@icesi.edu.co',
        );
  }
}
