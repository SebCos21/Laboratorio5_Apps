import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laboratorio5_apps/main.dart';

void main() {
  testWidgets('el login valida que los campos no estén vacíos', (tester) async {
    await tester.pumpWidget(const App());
    expect(find.text('Bienvenido de nuevo'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Iniciar sesión'));
    await tester.pump();

    expect(find.text('Escribe tu correo y tu contraseña'), findsOneWidget);
  });
}
