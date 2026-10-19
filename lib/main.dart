import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:laboratorio5_apps/features/auth/data/repository/auth_repository_impl.dart';
import 'package:laboratorio5_apps/features/auth/data/repository/profile_repository_impl.dart';
import 'package:laboratorio5_apps/features/auth/data/source/supabase_auth_data_source.dart';
import 'package:laboratorio5_apps/features/auth/data/source/supabase_profile_data_source.dart';
import 'package:laboratorio5_apps/features/auth/domain/entities/profile.dart';
import 'package:laboratorio5_apps/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:laboratorio5_apps/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:laboratorio5_apps/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:laboratorio5_apps/features/home/ui/screens/home_screen.dart';
import 'package:laboratorio5_apps/features/login/ui/bloc/login_bloc.dart';
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
        '/login': (_) => BlocProvider(
          // Igual que en el registro: el `create` arma la cadena completa.
          create: (_) => LoginBloc(
            SignInUseCase(
              AuthRepositoryImpl(
                SupabaseAuthDataSource(Supabase.instance.client),
              ),
              ProfileRepositoryImpl(
                SupabaseProfileDataSource(Supabase.instance.client),
              ),
            ),
          ),
          child: const LoginScreen(),
        ),
        '/register': (_) => BlocProvider(
          // El `create` es el único lugar donde se arma la cadena completa,
          // con sus dos ramas.
          create: (_) => RegisterBloc(
            SignUpUseCase(
              AuthRepositoryImpl(
                SupabaseAuthDataSource(Supabase.instance.client),
              ),
              ProfileRepositoryImpl(
                SupabaseProfileDataSource(Supabase.instance.client),
              ),
            ),
          ),
          child: const RegisterScreen(),
        ),
        '/home': (context) {
          // La ruta recibe el `Profile` que mandó el login o el registro.
          final profile = ModalRoute.of(context)!.settings.arguments as Profile;

          return HomeScreen(
            username: profile.username,
            fullName: profile.fullName,
            // El correo no vive en `profiles`: se lee de la sesión de Auth.
            email: Supabase.instance.client.auth.currentUser?.email ?? '',
            signOut: SignOutUseCase(
              AuthRepositoryImpl(
                SupabaseAuthDataSource(Supabase.instance.client),
              ),
            ),
          );
        },
      },
    );
  }
}
