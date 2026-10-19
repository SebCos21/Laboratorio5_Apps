# Laboratorio 5 · Registro e inicio de sesión con Supabase

App Flutter construida sobre el proyecto base del laboratorio
([Domiciano/262App3](https://github.com/Domiciano/262App3)): se conservan las
pantallas ya dibujadas, el tema y la navegación por rutas nombradas. Lo que se
trabajó aquí es la conexión por capas con Supabase: **registro**, **inicio de
sesión**, **perfil** y **cierre de sesión**.

La idea central del laboratorio es que un formulario tiene **dos destinos**:

- **Auth** guarda el correo y la contraseña y devuelve un `id`.
- **La tabla `profiles`** guarda ese mismo `id` junto con el usuario y el nombre.

Ni la contraseña ni el `id` se inventan en la app: el `id` siempre lo devuelve
Auth y se usa como llave foránea en `profiles`.

---

## 1. Requisitos

- Flutter 3.x (el proyecto declara `sdk: ^3.12.2`).
- Un proyecto de Supabase con Auth por correo y la tabla `profiles`.
- Para probar en el emulador o en el navegador: `flutter run -d chrome`
  (o el dispositivo que tengas configurado).

Dependencias principales (ya en `pubspec.yaml`):

```yaml
flutter_bloc: ^9.1.1
supabase_flutter: ^2.18.3
```

---

## 2. Configurar Supabase paso a paso

### 2.1. Opción rápida: usar el proyecto que ya trae el repo

`lib/main.dart` ya tiene la URL y la publishable key del proyecto del
laboratorio:

```dart
await Supabase.initialize(
  url: 'https://pmijmrkaucdwadmnnvbo.supabase.co',
  publishableKey: 'sb_publishable_8tS9o_mjkvKA4z9WUvRjCg_01oNcv6y',
);
```

Si el profesor entrega credenciales nuevas, solo reemplaza esos dos valores.
No hay que tocar ninguna otra parte del código.

### 2.2. Opción completa: crear tu propio proyecto

1. Entra a <https://supabase.com/dashboard> y crea un proyecto nuevo.
2. Ve a **Project Settings → API** (o **Data API**) y copia:
   - **Project URL** → va en `url`.
   - **Publishable key** (antes `anon key`) → va en `publishableKey`.
3. Pega ambos valores en `lib/main.dart`.
4. En **Authentication → Sign In / Providers → Email** deja habilitado el
   proveedor por correo.
5. Para que el registro deje la sesión abierta de inmediato, desactiva
   **Confirm email**. En el repo esto también está en `supabase/config.toml`:

   ```toml
   [auth.email]
   enable_signup = true
   enable_confirmations = false
   ```

   Si dejas la confirmación activada, el registro crea el usuario pero
   `response.user` puede llegar sin sesión y el insert del perfil falla.

### 2.3. Crear la tabla `profiles`

En **SQL Editor → New query**, ejecuta:

```sql
-- Tabla del perfil: el id es el mismo de auth.users.
create table public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  username text not null,
  full_name text not null,
  email text not null
);

-- Permisos para usuarios autenticados (sin esto: "permission denied").
grant select, insert, update on public.profiles to authenticated;
```

> El `on delete cascade` hace que, si borras la cuenta en **Authentication →
> Users**, su fila de `profiles` se borre también.

> **Sobre `email`**: la guía del laboratorio describe la tabla con tres
> columnas (`id`, `username`, `full_name`). Las migraciones de este repo
> incluyen además `email not null`, y por eso la entidad `Profile` y el `insert`
> también llevan el correo. Si prefieres la tabla de tres columnas, elimina la
> línea `'email': profile.email` de
> `lib/features/auth/data/source/supabase_profile_data_source.dart`.

### 2.4. Activar RLS y crear las policies (recomendado)

Sin RLS, cualquier usuario autenticado podría leer o escribir filas de otros.
Con RLS activado y estas policies, cada usuario solo ve y crea su propio
perfil:

```sql
alter table public.profiles enable row level security;

create policy "perfil propio: leer"
  on public.profiles for select
  to authenticated
  using (auth.uid() = id);

create policy "perfil propio: crear"
  on public.profiles for insert
  to authenticated
  with check (auth.uid() = id);

create policy "perfil propio: actualizar"
  on public.profiles for update
  to authenticated
  using (auth.uid() = id)
  with check (auth.uid() = id);
```

Si el proyecto ya tiene policies con esos nombres, no las vuelvas a crear
(Postgres respondería `already exists`).

### 2.5. Migraciones con la CLI (opcional)

Si prefieres versionar el esquema, el repo ya trae `supabase/migrations/`. Con
la CLI instalada:

```sh
npx supabase login
npx supabase link --project-ref TU_PROJECT_REF
npx supabase db push
```

Si el proyecto ya tiene la tabla creada desde el panel, es más simple quedarse
con el SQL del punto 2.3 y no volver a crearla.

### 2.6. Verificar que quedó bien

Antes de abrir la app, confirma en el dashboard:

1. **Table Editor → profiles**: deben existir las columnas `id`, `username`,
   `full_name` y (si aplica) `email`.
2. **Authentication → Users**: debe estar vacío o con los usuarios de prueba.
3. En **Authentication → Policies** (o en el SQL Editor con
   `select * from pg_policies where tablename = 'profiles';`) deben aparecer
   las policies si activaste RLS.

---

## 3. Ejecutar la app

```sh
flutter pub get
flutter run
```

Para correr en el navegador:

```sh
flutter run -d chrome
```

Para revisar el código sin ejecutar:

```sh
flutter analyze
flutter test
```

Los tests no necesitan Supabase ni internet: usan dobles escritos a mano en
`test/fakes.dart`.

---

## 4. Arquitectura: el mapa del laboratorio

Todo se organiza en tres capas. La presentación **no** conoce Supabase; el
dominio solo conoce contratos; los datos son los únicos que hablan con el SDK.

```
PRESENTACIÓN        RegisterScreen / LoginScreen / HomeScreen
                            │ eventos y estados
                            ▼
                    RegisterBloc / LoginBloc
                            │ llama un caso de uso
                            ▼
DOMINIO             SignUpUseCase / SignInUseCase / SignOutUseCase
                            │ usa contratos
                            ▼
                    AuthRepository      ProfileRepository
                            │ implementados por
                            ▼
DATOS               AuthRepositoryImpl  ProfileRepositoryImpl
                            │ delegan en
                            ▼
                    SupabaseAuthDataSource   SupabaseProfileDataSource
                            │
                            ▼
SUPABASE            Supabase Auth            tabla profiles
```

Reglas que sigue el código:

- La contraseña solo viaja hasta Auth; no está en `AuthUser` ni en `Profile`.
- `Profile` es lo que guardas tú: `id`, `username`, `fullName` (y `email` en
  este repo por la columna `not null`).
- Cada repositorio habla con **su** entidad: Auth devuelve `AuthUser` y
  `profiles` devuelve `Profile`.
- Los data sources traducen `AuthException` y `PostgrestException` a
  `AppException`; por eso los blocs no importan `supabase_flutter`.
- Un caso de uso es el único que conoce los dos lados y decide el orden.
- El `Bloc` no sabe que hay dos pasos: llama una vez al caso de uso y espera un
  `Profile`.

### Estructura de archivos

```
lib/
├── main.dart                              # Supabase.initialize + tema + rutas
├── theme/app_theme.dart                   # AppColors y buildTheme()
├── components/
│   ├── primary_button.dart                # botón con estado de carga
│   ├── error_message.dart                 # mensaje de error bajo el formulario
│   └── profile_field.dart                 # fila de dato del perfil
└── features/
    ├── auth/
    │   ├── domain/
    │   │   ├── entities/auth_user.dart            # id + email (lo de Auth)
    │   │   ├── entities/profile.dart              # id + username + fullName (+ email)
    │   │   ├── errors/app_exception.dart          # error de dominio (sin SDK)
    │   │   ├── repository/auth_repository.dart    # signUp, signIn, signOut
    │   │   ├── repository/profile_repository.dart # createProfile, getProfile
    │   │   └── usecases/
    │   │       ├── sign_up_usecase.dart           # Auth → profiles
    │   │       ├── sign_in_usecase.dart           # Auth → profiles
    │   │       └── sign_out_usecase.dart          # Auth.signOut
    │   └── data/
    │       ├── source/supabase_auth_data_source.dart
    │       ├── source/supabase_profile_data_source.dart
    │       ├── repository/auth_repository_impl.dart
    │       └── repository/profile_repository_impl.dart
    ├── register/ui/
    │   ├── bloc/register_event.dart
    │   ├── bloc/register_state.dart
    │   ├── bloc/register_bloc.dart
    │   └── screens/register_screen.dart
    ├── login/ui/
    │   ├── bloc/login_event.dart
    │   ├── bloc/login_state.dart
    │   ├── bloc/login_bloc.dart
    │   └── screens/login_screen.dart
    └── home/ui/screens/home_screen.dart

test/
├── fakes.dart                             # dobles de Auth y profiles
├── register_bloc_test.dart
├── register_screen_test.dart
├── login_bloc_test.dart
├── login_screen_test.dart
└── home_screen_test.dart
```

---

## 5. Paso a paso de lo que se implementó

### Preparación

- Se partió del proyecto base y se conservaron las pantallas, el tema y las
  rutas nombradas.
- `main.dart` inicializa Supabase y declara `/login`, `/register` y `/home`.

### Paso 1 · El Bloc del registro

Archivos: `register_event.dart`, `register_state.dart`, `register_bloc.dart`.

- `RegisterSubmitted` lleva `username`, `fullName`, `email` y `password`.
- `RegisterState` es **una sola clase** con
  `RegisterStatus { initial, loading, success, failure }` y `copyWith`.
- `success` lleva el `Profile`; `failure` lleva `errorMessage`.
- El Bloc emite `loading`, llama a `SignUpUseCase` una vez y emite `success` o
  `failure`. No importa Supabase.

### Paso 2 · Conectar la pantalla de registro

Archivo: `register_screen.dart`.

- `_submit()` valida los campos y lanza `RegisterSubmitted`; ya no navega.
- El formulario lee del estado `isLoading` y `errorMessage`.
- Un `BlocListener` navega a `/home` con `arguments: state.profile` cuando el
  estado es `success`.

### Paso 3 · Las dos entidades

Archivos: `auth_user.dart` y `profile.dart`.

```dart
class AuthUser {
  final String id;
  final String email;
}

class Profile {
  final String id;
  final String username;
  final String fullName;
  final String email; // extra de este repo (columna not null)
}
```

La contraseña no está en ninguna de las dos.

### Paso 4 · Los contratos

Archivos: `auth_repository.dart` y `profile_repository.dart`.

```dart
abstract class AuthRepository {
  Future<AuthUser> signUp({required String email, required String password});
  Future<AuthUser> signIn({required String email, required String password});
  Future<void> signOut();
}

abstract class ProfileRepository {
  Future<void> createProfile(Profile profile);
  Future<Profile> getProfile(String id);
}
```

(`signIn`, `signOut` y `getProfile` se agregaron en la Parte 2.)

### Paso 5 · El caso de uso del registro

Archivo: `sign_up_usecase.dart`.

1. Llama a `_auth.signUp(email, password)` y recibe el `AuthUser`.
2. Arma el `Profile` con `user.id`, `username`, `fullName` y `email`.
3. Llama a `_profiles.createProfile(profile)`.
4. Devuelve el `Profile` (es lo que necesita el estado `success`).

### Paso 6 · Los datos de Auth

Archivos: `supabase_auth_data_source.dart` y `auth_repository_impl.dart`.

- El data source recibe el `SupabaseClient` por constructor.
- `signUp` usa `_client.auth.signUp(...)`, valida que `response.user` no sea
  `null` y lo convierte en `AuthUser`.
- `signIn` usa `_client.auth.signInWithPassword(...)` con la misma validación.
- `signOut` usa `_client.auth.signOut()`.
- Traduce los errores del SDK (`AuthException`) a `AppException`, el error de
  dominio que sí pueden ver los blocs.
- El repositorio solo delega.

### Paso 7 · Los datos del perfil

Archivos: `supabase_profile_data_source.dart` y
`profile_repository_impl.dart`.

- `createProfile` hace el `insert` en `profiles`; es el único archivo que
  traduce `fullName` (Dart) → `full_name` (columna).
- `getProfile` hace `select().eq('id', id).single()` y arma el `Profile`.
- Traduce `PostgrestException` a `AppException`, igual que el data source de
  Auth.
- El repositorio solo delega.

### Paso 8 · `main.dart`

- `Supabase.initialize(...)` antes de `runApp`.
- La ruta `/register` envuelve la pantalla en un `BlocProvider`; el `create`
  arma la cadena completa:

  ```
  RegisterBloc → SignUpUseCase → AuthRepositoryImpl → SupabaseAuthDataSource
                              → ProfileRepositoryImpl → SupabaseProfileDataSource
  ```

### Paso 9 · `HomeScreen`

- La ruta `/home` lee el `Profile` de
  `ModalRoute.of(context)!.settings.arguments` y se lo pasa a `HomeScreen`
  (`username`, `fullName`, `email`).
- El botón **Cerrar sesión** llama a `SignOutUseCase` antes de volver a
  `/login`, para que la sesión no quede abierta en Supabase.

### Parte 2 · Inicio de sesión y cierre de sesión

1. **Contratos**: se agregaron `AuthRepository.signIn`, `AuthRepository.signOut`
   y `ProfileRepository.getProfile`.
2. **Datos**: `signInWithPassword`, `signOut`, `select ... single()` en los data
   sources, y sus implementaciones en los repositorios.
3. **`SignInUseCase`**:
   - `signIn` devuelve el `AuthUser`;
   - con su `id`, `getProfile` trae el perfil;
   - el correo que se muestra es el de Auth (`user.email`).
4. **`SignOutUseCase`**: llama a `AuthRepository.signOut`.
5. **`LoginBloc`**: `LoginStatus { initial, loading, success, failure }`,
   `LoginState` con `copyWith`; `success` lleva el `Profile`.
6. **`LoginScreen`**: valida los campos, lanza `LoginSubmitted`, muestra carga y
   errores, y navega a `/home` con `arguments: state.profile`.
7. **Ruta `/login`**: envuelta en `BlocProvider` con la cadena
   `LoginBloc → SignInUseCase → las dos ramas`.

---

## 6. Rutas

| Ruta | Pantalla | Qué hace |
| --- | --- | --- |
| `/login` | `LoginScreen` | Valida, inicia sesión con Supabase y navega a `/home` con el `Profile` |
| `/register` | `RegisterScreen` | Crea la cuenta en Auth, guarda el perfil y navega a `/home` con el `Profile` |
| `/home` | `HomeScreen` | Muestra usuario, nombre y correo reales; permite cerrar sesión |

---

## 7. Flujos completos

### Registro

```
RegisterScreen
  └─ RegisterSubmitted
       └─ RegisterBloc (loading)
            └─ SignUpUseCase
                 ├─ AuthRepository.signUp ──► auth.users (correo + contraseña)
                 └─ ProfileRepository.createProfile(id de Auth)
                        └─ insert en profiles (id, username, full_name, email)
       └─ RegisterBloc (success con Profile)
            └─ Navigator → /home (arguments: Profile)
```

### Inicio de sesión

```
LoginScreen
  └─ LoginSubmitted
       └─ LoginBloc (loading)
            └─ SignInUseCase
                 ├─ AuthRepository.signIn ──► signInWithPassword
                 └─ ProfileRepository.getProfile(id de Auth)
                        └─ select en profiles
       └─ LoginBloc (success con Profile)
            └─ Navigator → /home (arguments: Profile)
```

### Cerrar sesión

```
HomeScreen (botón)
  └─ SignOutUseCase → AuthRepository.signOut → auth.signOut()
       └─ Navigator → /login (sin dejar historial)
```

---

## 8. Prueba manual de extremo a extremo

1. Ejecuta `flutter run`.
2. En **Regístrate**, crea una cuenta con usuario, nombre completo, correo y
   contraseña (ambas iguales).
3. Debe navegar a **Perfil** mostrando tu nombre, `@usuario` y el correo.
4. En el dashboard de Supabase:
   - **Authentication → Users**: aparece la cuenta con su UID.
   - **Table Editor → profiles**: aparece una fila cuyo `id` es ese mismo UID,
     con tu `username` y `full_name`.
5. Toca **Cerrar sesión**: debe volver al login.
6. Inicia sesión con el mismo correo y contraseña: debe volver al perfil con
   los datos guardados.
7. Prueba un error: contraseña incorrecta → mensaje de credenciales inválidas,
   sin navegar.

---

## 9. Tests

```sh
flutter analyze   # 0 issues
flutter test      # 13 tests
```

- `register_bloc_test.dart`: el caso de uso guarda el perfil con el `id` de Auth
  y el Bloc emite `loading` → `success` o `failure`; también verifica que el
  mensaje de `AppException` llegue al estado.
- `register_screen_test.dart`: validaciones, navegación con `Profile` y error.
- `login_bloc_test.dart`: `loading` → `success` con el perfil y `failure` si
  Auth falla (sin consultar `profiles`), incluido el mensaje de `AppException`.
- `login_screen_test.dart`: navegación con `Profile`, error y campos vacíos.
- `home_screen_test.dart`: muestra los datos y llama a `signOut` antes de
  volver a `/login`.

Los tests usan `test/fakes.dart`, no Supabase, así que corren sin internet.

---

## 10. Problemas comunes

| Síntoma | Causa y solución |
| --- | --- |
| `permission denied for table profiles` | Falta el `grant` a `authenticated` o una policy de `insert`/`select`. Ejecuta el SQL del punto 2.3 y 2.4. |
| `null value in column "email" ... violates not-null constraint` | Tu tabla tiene `email not null`, pero el insert no lo envía. Este repo sí lo envía; si quitaste la línea, vuelve a agregarla. |
| `Could not find the 'email' column` | Tu tabla tiene solo tres columnas. Quita `'email': profile.email` del data source. |
| `Invalid login credentials` | Correo o contraseña incorrectos, o el usuario no existe. |
| `Email not confirmed` | El proyecto exige confirmar el correo. Desactiva **Confirm email** o confirma el usuario en el dashboard. |
| El registro falla con `null check operator used on a null value` | No se validó `response.user`. Este código lo valida y lanza un `AuthException`. |
| El login entra pero `/home` muestra datos de ejemplo | La ruta no está pasando el `Profile`. Revisa `arguments: state.profile` y el `ModalRoute.of(context)!...arguments`. |
| Al cerrar sesión se puede volver atrás y sigue "logueado" | El botón debe llamar a `SignOutUseCase` **antes** de navegar (así está en `HomeScreen`). |
| La app pide confirmar correo y no llega el enlace | Usa un correo real o desactiva la confirmación para el laboratorio. |

---

## 11. Notas sobre la guía

- El código sigue el orden del mapa del laboratorio: entidades → contratos →
  caso de uso → datos → `main.dart` → `HomeScreen` → Parte 2.
- `Profile` incluye `email` porque la tabla de las migraciones del proyecto base
  lo declara `not null`. La guía lo omite; si usas su tabla de tres columnas,
  revisa el aviso del punto 2.3.
- Los data sources reciben el `SupabaseClient` por constructor, y `main.dart`
  arma la cadena completa dentro del `create` de cada `BlocProvider`.
- La sesión de Supabase se mantiene entre reinicios de la app; después de
  **Cerrar sesión** se limpia y la app vuelve al login.
