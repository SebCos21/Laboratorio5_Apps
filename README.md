# Laboratorio 5 · Registro de usuarios con Supabase

Estructura inicial de la app Flutter organizada con Clean Architecture y Bloc.
Incluye los contratos, los stubs de la capa de datos y las pantallas mínimas de
login y registro. La lógica y el diseño se completan en la fase de la guía.

## Requisitos

- Flutter 3.44 o superior (Dart 3.12+).
- Un proyecto de Supabase con la tabla `profiles` creada
  (`supabase/schema.sql`).

## Configuración de Supabase

1. Crea el proyecto en [supabase.com](https://supabase.com).
2. Ejecuta `supabase/schema.sql` en el SQL Editor.
3. Copia la URL y la key pública del proyecto (Settings > API). Puede ser la
   `anon key` clásica o la `publishable key` nueva.
4. Ejecuta la app pasando las credenciales en tiempo de compilación:

```sh
flutter run ^
  --dart-define=SUPABASE_URL=https://tu-proyecto.supabase.co ^
  --dart-define=SUPABASE_ANON_KEY=tu-anon-key
```

No hay credenciales escritas en el repositorio. Si faltan, la app arranca en el
login con un aviso visible.

> Para el registro, desactiva la confirmación por correo en
> Authentication > Providers > Email mientras trabajas el flujo de la guía.

## Estructura

```
lib/
├── main.dart                 # Supabase.initialize + DI + runApp
├── app.dart                  # MaterialApp.router + tema
├── core/
│   ├── config/               # credenciales por --dart-define
│   ├── di/                   # registro en get_it
│   ├── errors/               # Failure y mapeo de excepciones
│   ├── router/               # rutas y redirect por sesión
│   ├── theme/                # tema base
│   └── utils/                # validadores de formularios
└── features/
    ├── auth/
    │   ├── domain/           # AuthUser, AuthRepository, casos de uso
    │   ├── data/             # data source (stub) + repositorio
    │   └── presentation/     # AuthBloc, LoginBloc, SignUpBloc y pantallas
    └── profile/
        ├── domain/           # Profile, ProfileRepository, casos de uso
        ├── data/             # data source (stub), ProfileModel, repositorio
        └── presentation/     # HomePage temporal
```

`SignUpUseCase` es el único punto que conoce los dos destinos: primero crea la
cuenta en Auth y después guarda el perfil con el `id` devuelto.

## Estado actual

- ✅ Estructura de carpetas, entidades, contratos y DI.
- ✅ Rutas `/login`, `/signup` y `/home` con redirect por sesión.
- ✅ Formularios con validación local y eventos de Bloc.
- ⏳ Llamadas reales a Supabase (`UnimplementedError` marcados con TODO).
- ⏳ Handlers de los blocs.
- ⏳ Diseño final según las imágenes de la guía.

## Comandos

```sh
flutter analyze
flutter test
```
