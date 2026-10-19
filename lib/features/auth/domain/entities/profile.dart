/// Fila de la tabla `profiles`: lo que guardas tú.
///
/// La guía deja `id`, `username` y `fullName`. El correo vive solo en Auth
/// ([AuthUser]); la contraseña tampoco aparece aquí: solo viaja hasta Auth.
class Profile {
  final String id;
  final String username;
  final String fullName;

  const Profile({
    required this.id,
    required this.username,
    required this.fullName,
  });
}
