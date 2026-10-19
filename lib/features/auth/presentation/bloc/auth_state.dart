import 'package:equatable/equatable.dart';

import '../../domain/entities/auth_user.dart';

enum AuthStatus {
  /// Todavía no se consultó la sesión persistida.
  unknown,
  authenticated,
  unauthenticated,
}

/// Estado global de la sesión.
///
/// `go_router` lo usa para decidir si muestra login o inicio.
class AuthState extends Equatable {
  const AuthState._({required this.status, this.user});

  const AuthState.unknown() : this._(status: AuthStatus.unknown);

  const AuthState.authenticated(AuthUser user)
    : this._(status: AuthStatus.authenticated, user: user);

  const AuthState.unauthenticated()
    : this._(status: AuthStatus.unauthenticated);

  final AuthStatus status;
  final AuthUser? user;

  bool get isAuthenticated => status == AuthStatus.authenticated;

  @override
  List<Object?> get props => [status, user];
}
