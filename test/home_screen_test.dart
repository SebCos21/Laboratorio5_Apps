import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laboratorio5_apps/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:laboratorio5_apps/features/home/ui/screens/home_screen.dart';
import 'package:laboratorio5_apps/theme/app_theme.dart';

import 'fakes.dart';

void main() {
  testWidgets('muestra el perfil y cierra sesión antes de volver a /login', (
    tester,
  ) async {
    final auth = FakeAuthRepository();

    await tester.pumpWidget(
      MaterialApp(
        theme: buildTheme(),
        initialRoute: '/home',
        routes: {
          '/home': (_) => HomeScreen(
            username: 'ana',
            fullName: 'Ana Gómez',
            email: 'ana@icesi.edu.co',
            signOut: SignOutUseCase(auth),
          ),
          '/login': (_) => const Scaffold(body: Text('Iniciar sesión')),
        },
      ),
    );

    expect(find.text('@ana'), findsOneWidget);
    expect(find.text('Ana Gómez'), findsWidgets);
    expect(find.text('ana@icesi.edu.co'), findsOneWidget);

    await tester.ensureVisible(
      find.widgetWithText(FilledButton, 'Cerrar sesión'),
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Cerrar sesión'));
    await tester.pumpAndSettle();

    expect(auth.signOutCalls, 1);
    expect(find.text('Iniciar sesión'), findsOneWidget);
  });
}
