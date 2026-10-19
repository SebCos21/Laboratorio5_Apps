import '../entities/profile.dart';

/// Contrato del lado derecho del mapa: el perfil en tu tabla `profiles`.
///
/// Un contrato dice qué se puede pedir, no quién lo cumple. Cada repositorio
/// habla con su propia entidad, así que aquí solo entra `Profile`.
abstract class ProfileRepository {
  /// Guarda la fila del perfil (ya trae el `id` que devolvió Auth).
  Future<void> createProfile(Profile profile);

  /// Trae el perfil que corresponde al `id` que devolvió Auth.
  Future<Profile> getProfile(String id);
}
