import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laboratorio5_apps/features/auth/domain/entities/profile.dart';
import 'package:laboratorio5_apps/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:laboratorio5_apps/features/login/ui/bloc/login_bloc.dart';
import 'package:laboratorio5_apps/features/login/ui/screens/login_screen.dart';
import 'package:laboratorio5_apps/theme/app_theme.dart';

import 'fakes.dart';

void main() {
  Widget buildApp(LoginBloc bloc) {
    return MaterialApp(
      theme: buildTheme(),
      initialRoute: '/login',
      routes: {
        '/login': (_) => BlocProvider<LoginBloc>.value(
          value: bloc,
          child: const LoginScreen(),
        ),
        '/home': (context) {
          final profile =
              ModalRoute.of(context)?.settings.arguments as Profile?;
          return Scaffold(
            body: Center(
              child: Text('Perfil de ${profile?.username} <${profile?.email}>'),
            ),
          );
        },
      },
    );
  }

  Future<void> fillForm(WidgetTester tester) async {
    await tester.enterText(find.byType(TextField).at(0), 'ana@icesi.edu.co');
    await tester.enterText(find.byType(TextField).at(1), '123456');
  }

  Future<void> tapLogin(WidgetTester tester) async {
    await tester.ensureVisible(
      find.widgetWithText(FilledButton, 'Iniciar sesión'),
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Iniciar sesión'));
  }

  testWidgets('al iniciar sesión navega a /home con el Profile', (
    tester,
  ) async {
    final bloc = LoginBloc(
      SignInUseCase(FakeAuthRepository(), FakeProfileRepository()),
    );

    await tester.pumpWidget(buildApp(bloc));
    await fillForm(tester);
    await tapLogin(tester);
    await tester.pumpAndSettle();

    expect(find.text('Perfil de ana <ana@icesi.edu.co>'), findsOneWidget);
  });

  testWidgets('cuando el login falla muestra el mensaje y no navega', (
    tester,
  ) async {
    final bloc = LoginBloc(
      SignInUseCase(
        FakeAuthRepository(signInError: Exception('credenciales inválidas')),
        FakeProfileRepository(),
      ),
    );

    await tester.pumpWidget(buildApp(bloc));
    await fillForm(tester);
    await tapLogin(tester);
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.textContaining('No se pudo iniciar sesión'), findsOneWidget);
  });

  testWidgets('valida los campos vacíos sin llamar al Bloc', (tester) async {
    final bloc = LoginBloc(
      SignInUseCase(FakeAuthRepository(), FakeProfileRepository()),
    );

    await tester.pumpWidget(buildApp(bloc));
    await tapLogin(tester);
    await tester.pump();

    expect(find.text('Escribe tu correo y tu contraseña'), findsOneWidget);
  });
}
