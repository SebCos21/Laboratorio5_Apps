import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../router/app_router.dart';
import '../../features/auth/data/datasources/auth_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../../features/auth/domain/usecases/sign_in_usecase.dart';
import '../../features/auth/domain/usecases/sign_out_usecase.dart';
import '../../features/auth/domain/usecases/sign_up_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/login/login_bloc.dart';
import '../../features/auth/presentation/bloc/register/register_bloc.dart';
import '../../features/profile/data/datasources/profile_data_source.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/domain/usecases/create_profile_usecase.dart';
import '../../features/profile/domain/usecases/get_profile_usecase.dart';

/// Contenedor de dependencias de la aplicación.
final GetIt getIt = GetIt.instance;

/// Registra todas las dependencias de la estructura.
///
/// Es idempotente para poder llamarlo desde los tests sin duplicar registros.
void configureDependencies() {
  if (getIt.isRegistered<GoRouter>()) return;

  getIt
    // Data sources (los pasos 6 y 7 del mapa)
    ..registerLazySingleton<AuthDataSource>(SupabaseAuthDataSource.new)
    ..registerLazySingleton<ProfileDataSource>(SupabaseProfileDataSource.new)
    // Repositorios (paso 4 del mapa)
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(getIt<AuthDataSource>()),
    )
    ..registerLazySingleton<ProfileRepository>(
      () => ProfileRepositoryImpl(getIt<ProfileDataSource>()),
    )
    // Casos de uso de auth
    ..registerLazySingleton<SignInUseCase>(
      () => SignInUseCase(getIt<AuthRepository>()),
    )
    ..registerLazySingleton<SignUpUseCase>(
      () => SignUpUseCase(getIt<AuthRepository>(), getIt<ProfileRepository>()),
    )
    ..registerLazySingleton<SignOutUseCase>(
      () => SignOutUseCase(getIt<AuthRepository>()),
    )
    ..registerLazySingleton<GetCurrentUserUseCase>(
      () => GetCurrentUserUseCase(getIt<AuthRepository>()),
    )
    // Casos de uso de profile
    ..registerLazySingleton<CreateProfileUseCase>(
      () => CreateProfileUseCase(getIt<ProfileRepository>()),
    )
    ..registerLazySingleton<GetProfileUseCase>(
      () => GetProfileUseCase(getIt<ProfileRepository>()),
    )
    // Blocs
    ..registerLazySingleton<AuthBloc>(AuthBloc.new)
    ..registerFactory<LoginBloc>(LoginBloc.new)
    ..registerFactory<RegisterBloc>(() => RegisterBloc(getIt<SignUpUseCase>()))
    // Router
    ..registerLazySingleton<GoRouter>(() => createRouter(getIt<AuthBloc>()));
}
