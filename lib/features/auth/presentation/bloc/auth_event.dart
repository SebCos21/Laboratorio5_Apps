import 'package:equatable/equatable.dart';

import '../../domain/entities/auth_user.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// La app arrancó: hay que restaurar la sesión persistida.
final class AuthStarted extends AuthEvent {
  const AuthStarted();
}

/// Supabase notificó un cambio de sesión.
final class AuthSessionChanged extends AuthEvent {
  const AuthSessionChanged(this.user);

  final AuthUser? user;

  @override
  List<Object?> get props => [user];
}

/// El usuario pidió cerrar sesión.
final class AuthSignOutRequested extends AuthEvent {
  const AuthSignOutRequested();
}
