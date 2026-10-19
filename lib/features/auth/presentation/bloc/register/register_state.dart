import 'package:equatable/equatable.dart';

import '../../../domain/entities/auth_user.dart';

enum RegisterStatus { initial, loading, success, failure }

class RegisterState extends Equatable {
  const RegisterState._({required this.status, this.user, this.errorMessage});

  const RegisterState.initial() : this._(status: RegisterStatus.initial);

  const RegisterState.loading() : this._(status: RegisterStatus.loading);

  const RegisterState.success(AuthUser user)
    : this._(status: RegisterStatus.success, user: user);

  const RegisterState.failure(String message)
    : this._(status: RegisterStatus.failure, errorMessage: message);

  final RegisterStatus status;

  /// Usuario devuelto por Auth cuando la cuenta se creó correctamente.
  final AuthUser? user;

  final String? errorMessage;

  bool get isLoading => status == RegisterStatus.loading;

  @override
  List<Object?> get props => [status, user, errorMessage];
}
