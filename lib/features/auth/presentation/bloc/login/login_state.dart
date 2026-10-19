import 'package:equatable/equatable.dart';

enum LoginStatus { initial, loading, success, failure }

class LoginState extends Equatable {
  const LoginState._({required this.status, this.errorMessage});

  const LoginState.initial() : this._(status: LoginStatus.initial);

  const LoginState.loading() : this._(status: LoginStatus.loading);

  const LoginState.success() : this._(status: LoginStatus.success);

  const LoginState.failure(String message)
    : this._(status: LoginStatus.failure, errorMessage: message);

  final LoginStatus status;
  final String? errorMessage;

  bool get isLoading => status == LoginStatus.loading;

  @override
  List<Object?> get props => [status, errorMessage];
}
