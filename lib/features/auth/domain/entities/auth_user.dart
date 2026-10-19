/// Usuario que devuelve Supabase Auth.
///
/// Es lo que devuelve Auth: `id` y `email`. No guarda la contraseña (solo
/// viaja hasta Auth) ni los datos del perfil, que viven en `Profile`.
class AuthUser {
  final String id;
  final String email;

  const AuthUser({required this.id, required this.email});
}
