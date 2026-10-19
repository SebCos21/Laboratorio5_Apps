import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laboratorio5_apps/core/errors/failure.dart';
import 'package:laboratorio5_apps/features/auth/domain/entities/auth_user.dart';
import 'package:laboratorio5_apps/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:laboratorio5_apps/features/auth/presentation/bloc/register/register_bloc.dart';
import 'package:laboratorio5_apps/features/auth/presentation/bloc/register/register_event.dart';
import 'package:laboratorio5_apps/features/auth/presentation/bloc/register/register_state.dart';
import 'package:mocktail/mocktail.dart';

class MockSignUpUseCase extends Mock implements SignUpUseCase {}

void main() {
  const event = RegisterSubmitted(
    username: 'sebas',
    fullName: 'Sebastián Cosme',
    email: 'sebas@example.com',
    password: '123456',
  );
  const user = AuthUser(id: 'user-1', email: 'sebas@example.com');

  late MockSignUpUseCase signUpUseCase;

  setUp(() {
    signUpUseCase = MockSignUpUseCase();
  });

  void stubSignUp(Future<AuthUser> Function() answer) {
    when(
      () => signUpUseCase(
        email: any(named: 'email'),
        password: any(named: 'password'),
        username: any(named: 'username'),
        fullName: any(named: 'fullName'),
      ),
    ).thenAnswer((_) => answer());
  }

  blocTest<RegisterBloc, RegisterState>(
    'emite loading y success cuando el registro funciona',
    build: () {
      stubSignUp(() async => user);
      return RegisterBloc(signUpUseCase);
    },
    act: (bloc) => bloc.add(event),
    expect: () => [
      const RegisterState.loading(),
      const RegisterState.success(user),
    ],
  );

  blocTest<RegisterBloc, RegisterState>(
    'emite loading y failure cuando Supabase devuelve un error',
    build: () {
      stubSignUp(
        () async => throw const Failure(
          'El correo ya está registrado.',
          type: FailureType.auth,
        ),
      );
      return RegisterBloc(signUpUseCase);
    },
    act: (bloc) => bloc.add(event),
    expect: () => [
      const RegisterState.loading(),
      const RegisterState.failure('El correo ya está registrado.'),
    ],
  );
}
