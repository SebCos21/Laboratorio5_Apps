import 'package:flutter_test/flutter_test.dart';
import 'package:laboratorio5_apps/app.dart';
import 'package:laboratorio5_apps/core/di/injection.dart';
import 'package:laboratorio5_apps/features/auth/presentation/pages/login_page.dart';

void main() {
  setUpAll(configureDependencies);

  testWidgets('la aplicación inicia en la pantalla de login', (tester) async {
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();

    expect(find.byType(LoginPage), findsOneWidget);
    expect(find.text('Correo electrónico'), findsOneWidget);
    expect(find.text('Entrar'), findsOneWidget);
  });
}
