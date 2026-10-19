/// Configuración de Supabase leída en tiempo de compilación.
///
/// No se guardan credenciales en el repositorio. Para ejecutar la app:
///
/// ```sh
/// flutter run \
///   --dart-define=SUPABASE_URL=https://tu-proyecto.supabase.co \
///   --dart-define=SUPABASE_ANON_KEY=tu-anon-key
/// ```
///
/// También se acepta `SUPABASE_PUBLISHABLE_KEY` si el proyecto usa las
/// credenciales nuevas de Supabase.
abstract final class SupabaseConfig {
  static const String url = String.fromEnvironment('SUPABASE_URL');

  /// Acepta la publishable key nueva y la anon key clásica.
  static const String publishableKey = String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
    defaultValue: String.fromEnvironment('SUPABASE_ANON_KEY'),
  );

  /// Indica si las credenciales fueron provistas al compilar.
  static bool get isConfigured => url.isNotEmpty && publishableKey.isNotEmpty;
}
