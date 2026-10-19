import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/errors/failure.dart';
import '../../../domain/usecases/sign_up_usecase.dart';
import 'register_event.dart';
import 'register_state.dart';

/// Bloc del formulario de registro.
///
/// Sigue los pasos 1 y 5 del mapa: recibe el formulario, llama a
/// [SignUpUseCase] y expone loading, success o failure.
class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc(this._signUpUseCase) : super(const RegisterState.initial()) {
    on<RegisterSubmitted>(_onSubmitted);
  }

  final SignUpUseCase _signUpUseCase;

  Future<void> _onSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    emit(const RegisterState.loading());

    try {
      final user = await _signUpUseCase(
        email: event.email,
        password: event.password,
        username: event.username,
        fullName: event.fullName,
      );
      emit(RegisterState.success(user));
    } on Failure catch (failure) {
      emit(RegisterState.failure(failure.message));
    } catch (_) {
      emit(
        const RegisterState.failure(
          'No se pudo crear la cuenta. Intenta de nuevo.',
        ),
      );
    }
  }
}
