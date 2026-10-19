import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/domain/errors/app_exception.dart';
import '../../../auth/domain/usecases/sign_in_usecase.dart';
import 'login_event.dart';
import 'login_state.dart';

/// Bloc del formulario de inicio de sesión (Parte 2 del mapa).
///
/// No sabe que iniciar sesión son dos pasos: llama a [SignInUseCase] una sola
/// vez y espera el `Profile`. Quien reparte los datos entre Auth y la tabla
/// `profiles` es el caso de uso.
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final SignInUseCase _signIn;

  LoginBloc(this._signIn) : super(const LoginState()) {
    on<LoginSubmitted>(_onSubmitted);
  }

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(status: LoginStatus.loading));

    try {
      final profile = await _signIn(
        email: event.email,
        password: event.password,
      );
      emit(state.copyWith(status: LoginStatus.success, profile: profile));
    } on AppException catch (error) {
      emit(
        state.copyWith(
          status: LoginStatus.failure,
          errorMessage: error.message,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: LoginStatus.failure,
          errorMessage: 'No se pudo iniciar sesión. Intenta de nuevo.',
        ),
      );
    }
  }
}
