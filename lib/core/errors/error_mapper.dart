import 'package:supabase_flutter/supabase_flutter.dart';

import 'exceptions.dart';
import 'failure.dart';

/// Traduce cualquier excepción a un [Failure] de dominio.
///
/// Es el único lugar que conoce las excepciones concretas de Supabase.
Failure mapErrorToFailure(Object error) {
  return switch (error) {
    Failure() => error,
    ServerException() => Failure(error.message, code: error.code),
    AuthException() => Failure(
      error.message,
      type: FailureType.auth,
      code: error.statusCode,
    ),
    PostgrestException() => Failure(
      error.message,
      type: FailureType.profile,
      code: error.code,
    ),
    _ => const Failure('Ocurrió un error inesperado. Intenta de nuevo.'),
  };
}
