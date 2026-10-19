/// Fila de la tabla `profiles`: lo que guardas tú.
///
/// La guía deja `id`, `username` y `fullName`. Se conserva `email` porque la
/// tabla `profiles` del proyecto base lo declara `not null`, y el correo es
/// también el dato que muestra la pantalla de perfil.
///
/// La contraseña no aparece aquí ni en [AuthUser]: solo viaja hasta Auth.
class Profile {
  final String id;
  final String username;
  final String fullName;
  final String email;

  const Profile({
    required this.id,
    required this.username,
    required this.fullName,
    required this.email,
  });
}
