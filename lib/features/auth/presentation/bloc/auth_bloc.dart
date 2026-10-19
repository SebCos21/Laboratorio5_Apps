import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_event.dart';
import 'auth_state.dart';

/// Bloc de sesión: vive durante toda la app.
///
/// La lógica se completa en la fase de la guía. Por ahora deja el estado
/// inicial en `unauthenticated` para que el router muestre el login.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthState.unauthenticated()) {
    on<AuthStarted>(_onStarted);
    on<AuthSessionChanged>(_onSessionChanged);
    on<AuthSignOutRequested>(_onSignOutRequested);
  }

  void _onStarted(AuthStarted event, Emitter<AuthState> emit) {
    // TODO(guia): inyectar GetCurrentUserUseCase, restaurar la sesión y
    // escuchar AuthRepository.authStateChanges.
  }

  void _onSessionChanged(AuthSessionChanged event, Emitter<AuthState> emit) {
    final user = event.user;
    if (user == null) {
      emit(const AuthState.unauthenticated());
    } else {
      emit(AuthState.authenticated(user));
    }
  }

  void _onSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) {
    // TODO(guia): inyectar SignOutUseCase y emitir unauthenticated.
  }
}
