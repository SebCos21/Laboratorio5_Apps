import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laboratorio5_apps/features/auth/domain/entities/profile.dart';
import 'package:laboratorio5_apps/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:laboratorio5_apps/features/register/ui/bloc/register_bloc.dart';
import 'package:laboratorio5_apps/features/register/ui/screens/register_screen.dart';
import 'package:laboratorio5_apps/theme/app_theme.dart';

import 'fakes.dart';

void main() {
  Widget buildApp(RegisterBloc bloc) {
    return MaterialApp(
      theme: buildTheme(),
      initialRoute: '/register',
      routes: {
        '/register': (_) =>
            BlocProvider<RegisterBloc>.value(value: bloc, child: const RegisterScreen()),
        '/home': (context) {
          final profile = ModalRoute.of(context)?.settings.arguments as Profile?;
          return Scaffold(
            body: Center(child: Text('Perfil de ${profile?.username}')),
          );
        },
      },
    );
  }

  Future<void> fillForm(WidgetTester tester) async {
    await tester.enterText(find.byType(TextField).at(0), 'ana');
    await tester.enterText(find.byType(TextField).at(1), 'Ana Gómez');
    await tester.enterText(find.byType(TextField).at(2), 'ana@icesi.edu.co');
    await tester.enterText(find.byType(TextField).at(3), '123456');
    await tester.enterText(find.byType(TextField).at(4), '123456');
  }

  Future<void> tapRegister(WidgetTester tester) async {
    await tester.ensureVisible(
      find.widgetWithText(FilledButton, 'Registrarme'),
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Registrarme'));
  }

  testWidgets('al registrarse navega a /home con el Profile', (tester) async {
    final bloc = RegisterBloc(
      SignUpUseCase(
        FakeAuthRepository(),
        FakeProfileRepository(),
      ),
    );

    await tester.pumpWidget(buildApp(bloc));
    await fillForm(tester);
    await tapRegister(tester);
    await tester.pumpAndSettle();

    expect(find.text('Perfil de ana'), findsOneWidget);
  });

  testWidgets('cuando el registro falla muestra el mensaje y no navega', (
    tester,
  ) async {
    final bloc = RegisterBloc(
      SignUpUseCase(
        FakeAuthRepository(
          error: Exception('correo ya registrado'),
        ),
        FakeProfileRepository(),
      ),
    );

    await tester.pumpWidget(buildApp(bloc));
    await fillForm(tester);
    await tapRegister(tester);
    await tester.pumpAndSettle();

    expect(find.text('Perfil de null'), findsNothing);
    expect(find.byType(RegisterScreen), findsOneWidget);
    expect(find.textContaining('No se pudo crear la cuenta'), findsOneWidget);
  });

  testWidgets('rechaza contraseñas que no coinciden sin llamar al Bloc', (
    tester,
  ) async {
    final bloc = RegisterBloc(
      SignUpUseCase(FakeAuthRepository(), FakeProfileRepository()),
    );

    await tester.pumpWidget(buildApp(bloc));
    await fillForm(tester);
    await tester.enterText(find.byType(TextField).at(4), '654321');
    await tapRegister(tester);
    await tester.pump();

    expect(find.text('Las contraseñas no coinciden'), findsOneWidget);
  });
}
