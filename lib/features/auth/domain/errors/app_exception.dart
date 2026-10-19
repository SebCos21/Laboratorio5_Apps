/// Error de dominio: lo que las capas de arriba pueden mostrar.
///
/// Los data sources traducen los errores de Supabase a esta excepción, así el
/// Bloc y la vista no conocen ninguna clase del SDK.
class AppException implements Exception {
  final String message;

  const AppException(this.message);

  @override
  String toString() => message;
}
