/// Fila de la tabla `profiles`: lo que guardamos en tu base de datos.
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
