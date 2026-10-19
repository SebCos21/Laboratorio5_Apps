/// Usuario que devuelve Supabase Auth.
///
/// No guarda la contraseña: solo lo que la app necesita para identificar
/// la sesión.
class AuthUser {
  final String id;
  final String email;

  const AuthUser({required this.id, required this.email});
}
