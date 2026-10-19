import 'package:equatable/equatable.dart';

enum SignUpStatus { initial, loading, success, failure }

class SignUpState extends Equatable {
  const SignUpState._({required this.status, this.errorMessage});

  const SignUpState.initial() : this._(status: SignUpStatus.initial);

  const SignUpState.loading() : this._(status: SignUpStatus.loading);

  const SignUpState.success() : this._(status: SignUpStatus.success);

  const SignUpState.failure(String message)
    : this._(status: SignUpStatus.failure, errorMessage: message);

  final SignUpStatus status;
  final String? errorMessage;

  bool get isLoading => status == SignUpStatus.loading;

  @override
  List<Object?> get props => [status, errorMessage];
}
