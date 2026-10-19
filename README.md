# Laboratorio 5 · Registro de usuarios con Supabase

App Flutter construida sobre el proyecto base del laboratorio
([Domiciano/262App3](https://github.com/Domiciano/262App3)): mismas carpetas,
mismo tema y las tres pantallas ya dibujadas. Aquí se conectaron las capas de
adentro (dominio y datos) y el `RegisterBloc` siguiendo el mapa del laboratorio.

## Cómo correrlo

```sh
flutter pub get
flutter run
```

`main.dart` ya inicializa Supabase con el proyecto del laboratorio, así que no
hay que configurar credenciales.

> **Tabla `profiles`**: la guía usa tres columnas (`id`, `username`,
> `full_name`); las migraciones de este repo además tienen `email not null`, así
> que `Profile` y el `insert` incluyen `email`. Si tu tabla tiene solo tres
> columnas, quita la línea `'email': profile.email` del data source.

## Estructura

```
lib/
├── main.dart                       # Supabase.initialize + tema + rutas      (paso 8)
├── theme/app_theme.dart            # AppColors y buildTheme()
├── components/
│   ├── primary_button.dart         # botón con estado de carga
│   ├── error_message.dart          # mensaje de error bajo el formulario
│   └── profile_field.dart          # fila de dato del perfil
└── features/
    ├── auth/
    │   ├── domain/
    │   │   ├── entities/auth_user.dart            # lo que devuelve Auth   (paso 3)
    │   │   ├── entities/profile.dart              # lo que guardas en la tabla (paso 3)
    │   │   ├── repository/auth_repository.dart    # contrato de Auth       (paso 4)
    │   │   ├── repository/profile_repository.dart # contrato del perfil    (paso 4)
    │   │   └── usecases/sign_up_usecase.dart      # los dos pasos, en orden (paso 5)
    │   └── data/
    │       ├── source/supabase_auth_data_source.dart     # llamadas a Auth (paso 6)
    │       ├── source/supabase_profile_data_source.dart  # insert en profiles (paso 7)
    │       ├── repository/auth_repository_impl.dart      # cumple el contrato (paso 6)
    │       └── repository/profile_repository_impl.dart   # cumple el contrato (paso 7)
    ├── register/ui/
    │   ├── bloc/register_bloc.dart                 # eventos y estados     (paso 1)
    │   ├── bloc/register_event.dart
    │   ├── bloc/register_state.dart
    │   └── screens/register_screen.dart            # pantalla ya dibujada  (paso 2)
    ├── login/ui/screens/login_screen.dart          # Parte 2, con la misma forma
    └── home/ui/screens/home_screen.dart            # a dónde llega el registro (paso 9)
```

`SignUpUseCase` es la única pieza que conoce las dos columnas del mapa: primero
crea la cuenta en Auth y después guarda el perfil con el `id` que Auth devolvió.

## Rutas

| Ruta | Pantalla | Qué hace hoy |
| --- | --- | --- |
| `/login` | `LoginScreen` | Valida que los campos no estén vacíos y navega a `/home` |
| `/register` | `RegisterScreen` | Valida, lanza `OnRegisterSubmittedEvent` y navega a `/home` con `RegisterSuccessState` |
| `/home` | `HomeScreen` | Muestra el perfil con datos de ejemplo y vuelve a `/login` |

## Estado del laboratorio

- ✅ Pasos 1 a 9 del mapa: registro completo por las capas
  (`RegisterBloc` → `SignUpUseCase` → repositorios → data sources → Supabase).
- ✅ Paso 1 con la forma de la guía: `RegisterState` es una sola clase con
  `RegisterStatus { initial, loading, success, failure }` y `copyWith`; el
  `success` lleva el `Profile` y el `failure` el mensaje de error.
- ✅ `RegisterBloc` sin Supabase: llama a `SignUpUseCase` una sola vez y espera
  el `Profile`; `SignUpUseCase` es quien reparte los datos entre Auth y
  `profiles`.
- ✅ Pantallas del proyecto base con el `Bloc` conectado.
- ✅ Paso 2: `_submit()` lanza `RegisterSubmitted` (ya no navega), el formulario
  lee `isLoading` y el `ErrorMessage` del estado, y el `BlocListener` navega a
  `/home` pasando `arguments: state.profile`.
- ✅ Paso 3: `AuthUser` (`id`, `email`) y `Profile` (`id`, `username`,
  `fullName`) con el `email` extra que la tabla `profiles` exige `not null`.
  La contraseña no está en ninguna entidad: solo viaja hasta Auth.
- ✅ Paso 4: contratos `AuthRepository.signUp({email, password})` y
  `ProfileRepository.createProfile(Profile)`; cada uno habla con su entidad.
- ✅ Paso 5: `SignUpUseCase` llama una vez a Auth y luego guarda el perfil con
  el `id` devuelto.
- ✅ Paso 6: `SupabaseAuthDataSource` recibe el `SupabaseClient` por
  constructor, valida `response.user` y lo convierte en `AuthUser`;
  `AuthRepositoryImpl` delega en él.
- ✅ Paso 7: `SupabaseProfileDataSource` también recibe el cliente y es el único
  que traduce `fullName` → `full_name`; `ProfileRepositoryImpl` delega en él.
- ⏳ **Parte 2 (login)**: crear `login/ui/bloc` y conectar `LoginScreen`.
- ⏳ **Paso 9**: `HomeScreen` debe leer el `Profile` que llega en
  `ModalRoute.of(context)!.settings.arguments` en lugar de usar los datos de
  ejemplo, y que `Cerrar sesión` llame a `signOut` antes de navegar.
- ⏳ Confirmar las credenciales del proyecto si el profesor entrega unas nuevas.

## Tests

```sh
flutter analyze
flutter test
```

- `test/navigation_test.dart`: validaciones de login y registro.
- `test/register_bloc_test.dart`: el caso de uso guarda el perfil con el `id`
  que devuelve Auth y el Bloc emite `loading` → `success` o `error`.
