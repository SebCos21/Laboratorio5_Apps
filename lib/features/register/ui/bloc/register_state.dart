/// Estados que emite el RegisterBloc.
abstract class RegisterState {
  const RegisterState();
}

/// Formulario en reposo, listo para enviarse.
class RegisterIdleState extends RegisterState {}

/// El registro está en curso.
class RegisterLoadingState extends RegisterState {}

/// El registro falló: hay un mensaje para mostrar en pantalla.
class RegisterErrorState extends RegisterState {
  final String errorMessage;

  const RegisterErrorState({required this.errorMessage});
}

/// La cuenta y el perfil se guardaron correctamente.
class RegisterSuccessState extends RegisterState {}
