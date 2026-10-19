import '../../../auth/domain/entities/profile.dart';

/// Los cuatro momentos del formulario de registro.
enum RegisterStatus { initial, loading, success, failure }

/// Un solo estado: `status` dice en qué momento va y `copyWith` cambia
/// únicamente lo que hace falta.
///
/// - `initial`: se crea con `const RegisterState()`.
/// - `loading`: `copyWith(status: RegisterStatus.loading)`.
/// - `success`: `copyWith(status: ..., profile: ...)`.
/// - `failure`: `copyWith(status: ..., errorMessage: ...)`.
class RegisterState {
  final RegisterStatus status;

  /// Perfil guardado cuando el registro termina bien.
  final Profile? profile;

  /// Mensaje que se muestra bajo el formulario cuando algo falla.
  final String? errorMessage;

  const RegisterState({
    this.status = RegisterStatus.initial,
    this.profile,
    this.errorMessage,
  });

  RegisterState copyWith({
    RegisterStatus? status,
    Profile? profile,
    String? errorMessage,
  }) {
    return RegisterState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
