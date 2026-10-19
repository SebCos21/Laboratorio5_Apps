import 'package:equatable/equatable.dart';

/// Origen del error, útil para decidir qué mensaje mostrar.
enum FailureType { auth, profile, network, validation, unexpected }

/// Error de dominio que atraviesa las capas de la aplicación.
///
/// La capa de datos traduce excepciones de Supabase a esta clase para que
/// `presentation` no conozca detalles del proveedor.
class Failure extends Equatable implements Exception {
  const Failure(this.message, {this.type = FailureType.unexpected, this.code});

  final String message;
  final FailureType type;
  final String? code;

  @override
  List<Object?> get props => [message, type, code];

  @override
  String toString() => message;
}
