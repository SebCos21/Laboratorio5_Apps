/// Excepción propia de la capa de datos.
///
/// Los `data sources` la lanzan cuando el error del proveedor no tiene una
/// traducción directa a un `Failure` de dominio.
class ServerException implements Exception {
  const ServerException(this.message, {this.code});

  final String message;
  final String? code;

  @override
  String toString() => 'ServerException: $message';
}
