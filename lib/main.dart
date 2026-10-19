import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:laboratorio5_apps/features/auth/data/repository/auth_repository_impl.dart';
import 'package:laboratorio5_apps/features/auth/data/repository/profile_repository_impl.dart';
import 'package:laboratorio5_apps/features/auth/data/source/supabase_auth_data_source.dart';
import 'package:laboratorio5_apps/features/auth/data/source/supabase_profile_data_source.dart';
import 'package:laboratorio5_apps/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:laboratorio5_apps/features/home/ui/screens/home_screen.dart';
import 'package:laboratorio5_apps/features/login/ui/screens/login_screen.dart';
import 'package:laboratorio5_apps/features/register/ui/bloc/register_bloc.dart';
import 'package:laboratorio5_apps/features/register/ui/screens/register_screen.dart';
import 'package:laboratorio5_apps/theme/app_theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://pmijmrkaucdwadmnnvbo.supabase.co',
    publishableKey: 'sb_publishable_8tS9o_mjkvKA4z9WUvRjCg_01oNcv6y',
  );

  runApp(const App());
}

/// Root widget: aplica el tema y declara las rutas nombradas.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Laboratorio 5',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginScreen(),
        '/register': (_) => BlocProvider(
          create: (_) => RegisterBloc(_buildSignUpUseCase()),
          child: const RegisterScreen(),
        ),
        '/home': (_) => const HomeScreen(),
      },
    );
  }
}

/// Arma las capas de adentro: data source -> repositorio -> caso de uso.
SignUpUseCase _buildSignUpUseCase() {
  final client = Supabase.instance.client;

  return SignUpUseCase(
    AuthRepositoryImpl(SupabaseAuthDataSource(client)),
    ProfileRepositoryImpl(SupabaseProfileDataSource(client)),
  );
}
