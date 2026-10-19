import 'package:flutter_bloc/flutter_bloc.dart';

import 'login_event.dart';
import 'login_state.dart';

/// Bloc del formulario de inicio de sesión.
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginState.initial()) {
    on<LoginSubmitted>(_onSubmitted);
  }

  void _onSubmitted(LoginSubmitted event, Emitter<LoginState> emit) {
    // TODO(guia): emitir loading, llamar a SignInUseCase y luego success o
    // failure con el mensaje del Failure.
  }
}
