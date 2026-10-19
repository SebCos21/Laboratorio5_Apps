import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_screen.dart';
import '../../features/profile/presentation/pages/home_screen.dart';

abstract final class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
}

/// Escucha los cambios de sesión para que `go_router` reevalúe el redirect.
class _RouterRefresh extends ChangeNotifier {
  _RouterRefresh(Stream<dynamic> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

/// Crea el router con las rutas de la estructura inicial.
///
/// El redirect decide entre login/registro y la pantalla de inicio según el
/// estado de [AuthBloc].
GoRouter createRouter(AuthBloc authBloc) {
  final refresh = _RouterRefresh(authBloc.stream);

  return GoRouter(
    initialLocation: AppRoutes.login,
    refreshListenable: refresh,
    redirect: (context, state) {
      final status = authBloc.state.status;
      final location = state.matchedLocation;
      final isPublicRoute =
          location == AppRoutes.login || location == AppRoutes.register;

      if (status == AuthStatus.authenticated && isPublicRoute) {
        return AppRoutes.home;
      }
      if (status == AuthStatus.unauthenticated && !isPublicRoute) {
        return AppRoutes.login;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  );
}
