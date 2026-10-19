import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../auth/domain/usecases/sign_up_usecase.dart';
import 'register_event.dart';
import 'register_state.dart';

/// Bloc del formulario de registro (paso 1 del mapa).
///
/// No sabe que registrar son dos pasos: llama a [SignUpUseCase] una sola vez
/// y espera el `Profile`. Quien reparte los datos entre Auth y la tabla
/// `profiles` es el caso de uso.
class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final SignUpUseCase _signUp;

  RegisterBloc(this._signUp) : super(const RegisterState()) {
    on<RegisterSubmitted>(_onSubmitted);
  }

  Future<void> _onSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    emit(state.copyWith(status: RegisterStatus.loading));

    try {
      final profile = await _signUp(
        username: event.username,
        fullName: event.fullName,
        email: event.email,
        password: event.password,
      );
      emit(state.copyWith(status: RegisterStatus.success, profile: profile));
    } on AuthException catch (error) {
      emit(
        state.copyWith(
          status: RegisterStatus.failure,
          errorMessage: error.message,
        ),
      );
    } on PostgrestException catch (error) {
      emit(
        state.copyWith(
          status: RegisterStatus.failure,
          errorMessage: error.message,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: RegisterStatus.failure,
          errorMessage: 'No se pudo crear la cuenta. Intenta de nuevo.',
        ),
      );
    }
  }
}
