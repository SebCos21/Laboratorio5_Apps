import 'package:flutter_test/flutter_test.dart';
import 'package:laboratorio5_apps/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:laboratorio5_apps/features/login/ui/bloc/login_bloc.dart';
import 'package:laboratorio5_apps/features/login/ui/bloc/login_event.dart';
import 'package:laboratorio5_apps/features/login/ui/bloc/login_state.dart';

import 'fakes.dart';

void main() {
  const event = LoginSubmitted(email: 'ana@icesi.edu.co', password: '123456');

  test('emite loading y success con el Profile de profiles', () async {
    final auth = FakeAuthRepository();
    final profiles = FakeProfileRepository();
    final bloc = LoginBloc(SignInUseCase(auth, profiles));

    final expectation = expectLater(
      bloc.stream,
      emitsInOrder(<Matcher>[
        isA<LoginState>().having(
          (state) => state.status,
          'status',
          LoginStatus.loading,
        ),
        isA<LoginState>()
            .having((state) => state.status, 'status', LoginStatus.success)
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

    expect(auth.signInCalls, 1);
    expect(profiles.getProfileCalls, 1);
  });

  test(
    'emite loading y failure cuando Auth falla, sin leer profiles',
    () async {
      final auth = FakeAuthRepository(signInError: Exception('credenciales'));
      final profiles = FakeProfileRepository();
      final bloc = LoginBloc(SignInUseCase(auth, profiles));

      final expectation = expectLater(
        bloc.stream,
        emitsInOrder(<Matcher>[
          isA<LoginState>().having(
            (state) => state.status,
            'status',
            LoginStatus.loading,
          ),
          isA<LoginState>()
              .having((state) => state.status, 'status', LoginStatus.failure)
              .having(
                (state) => state.errorMessage,
                'errorMessage',
                isNotEmpty,
              ),
        ]),
      );

      bloc.add(event);
      await expectation;

      expect(profiles.getProfileCalls, 0);
    },
  );
}
