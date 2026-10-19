import '../../../auth/domain/entities/profile.dart';

/// Los cuatro momentos del formulario de inicio de sesión.
enum LoginStatus { initial, loading, success, failure }

/// Un solo estado: `status` dice en qué momento va y `copyWith` cambia
/// únicamente lo que hace falta.
///
/// - `initial`: se crea con `const LoginState()`.
/// - `loading`: `copyWith(status: LoginStatus.loading)`.
/// - `success`: `copyWith(status: ..., profile: ...)`.
/// - `failure`: `copyWith(status: ..., errorMessage: ...)`.
class LoginState {
  final LoginStatus status;

  /// Perfil que se muestra en `/home` cuando el login termina bien.
  final Profile? profile;

  /// Mensaje que se muestra bajo el formulario cuando algo falla.
  final String? errorMessage;

  const LoginState({
    this.status = LoginStatus.initial,
    this.profile,
    this.errorMessage,
  });

  LoginState copyWith({
    LoginStatus? status,
    Profile? profile,
    String? errorMessage,
  }) {
    return LoginState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
