import 'package:flutter_test/flutter_test.dart';
import 'package:laboratorio5_apps/features/auth/domain/entities/auth_user.dart';
import 'package:laboratorio5_apps/features/auth/domain/entities/profile.dart';
import 'package:laboratorio5_apps/features/auth/domain/repository/auth_repository.dart';
import 'package:laboratorio5_apps/features/auth/domain/repository/profile_repository.dart';
import 'package:laboratorio5_apps/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:laboratorio5_apps/features/register/ui/bloc/register_bloc.dart';
import 'package:laboratorio5_apps/features/register/ui/bloc/register_event.dart';
import 'package:laboratorio5_apps/features/register/ui/bloc/register_state.dart';

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

void main() {
  const event = RegisterSubmitted(
    username: 'ana',
    fullName: 'Ana Gómez',
    email: 'ana@icesi.edu.co',
    password: '123456',
  );

  late FakeAuthRepository auth;
  late FakeProfileRepository profile;

  RegisterBloc buildBloc() {
    return RegisterBloc(
      SignUpUseCase(authRepository: auth, profileRepository: profile),
    );
  }

  test('emite loading y success con el Profile guardado', () async {
    auth = FakeAuthRepository();
    profile = FakeProfileRepository();
    final bloc = buildBloc();

    final expectation = expectLater(
      bloc.stream,
      emitsInOrder(<Matcher>[
        isA<RegisterState>().having(
          (state) => state.status,
          'status',
          RegisterStatus.loading,
        ),
        isA<RegisterState>()
            .having((state) => state.status, 'status', RegisterStatus.success)
            .having((state) => state.profile?.username, 'username', 'ana')
            .having((state) => state.profile?.fullName, 'fullName', 'Ana Gómez')
            .having(
              (state) => state.profile?.email,
              'email',
              'ana@icesi.edu.co',
            ),
      ]),
    );

    bloc.add(event);
    await expectation;

    expect(auth.calls, 1);
    expect(profile.calls, 1);
    expect(profile.lastId, 'user-1');
  });

  test('emite loading y failure cuando Auth falla, sin tocar profiles', () async {
    auth = FakeAuthRepository(error: Exception('correo ya registrado'));
    profile = FakeProfileRepository();
    final bloc = buildBloc();

    final expectation = expectLater(
      bloc.stream,
      emitsInOrder(<Matcher>[
        isA<RegisterState>().having(
          (state) => state.status,
          'status',
          RegisterStatus.loading,
        ),
        isA<RegisterState>()
            .having((state) => state.status, 'status', RegisterStatus.failure)
            .having(
              (state) => state.errorMessage,
              'errorMessage',
              isNotEmpty,
            ),
      ]),
    );

    bloc.add(event);
    await expectation;

    expect(profile.calls, 0);
  });
}
