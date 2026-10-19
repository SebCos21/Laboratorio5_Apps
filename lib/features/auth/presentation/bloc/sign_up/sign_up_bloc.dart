import 'package:flutter_bloc/flutter_bloc.dart';

import 'sign_up_event.dart';
import 'sign_up_state.dart';

/// Bloc del formulario de registro.
class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(const SignUpState.initial()) {
    on<SignUpSubmitted>(_onSubmitted);
  }

  void _onSubmitted(SignUpSubmitted event, Emitter<SignUpState> emit) {
    // TODO(guia): emitir loading, llamar a SignUpUseCase y luego success o
    // failure con el mensaje del Failure.
  }
}
