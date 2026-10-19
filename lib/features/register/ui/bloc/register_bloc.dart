import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../auth/domain/usecases/sign_up_usecase.dart';
import 'register_event.dart';
import 'register_state.dart';

/// Bloc del formulario de registro.
///
/// No habla con Supabase: delega en [SignUpUseCase], que reparte los datos
/// entre Auth y la tabla `profiles`. Aquí solo se maneja loading, success y
/// el mensaje de error que ve el usuario.
class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final SignUpUseCase signUpUseCase;

  RegisterBloc(this.signUpUseCase) : super(RegisterIdleState()) {
    on<OnRegisterSubmittedEvent>(register);
  }

  Future<void> register(
    OnRegisterSubmittedEvent event,
    Emitter<RegisterState> emit,
  ) async {
    emit(RegisterLoadingState());

    try {
      await signUpUseCase(
        email: event.email,
        password: event.password,
        username: event.username,
        fullName: event.fullName,
      );
      emit(RegisterSuccessState());
    } on AuthException catch (error) {
      emit(RegisterErrorState(errorMessage: error.message));
    } on PostgrestException catch (error) {
      emit(RegisterErrorState(errorMessage: error.message));
    } catch (_) {
      emit(
        const RegisterErrorState(
          errorMessage: 'No se pudo crear la cuenta. Intenta de nuevo.',
        ),
      );
    }
  }
}
