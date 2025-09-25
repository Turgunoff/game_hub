// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:game_hub/core/di_module.dart' as _i865;
import 'package:game_hub/core/network/dio_client.dart' as _i689;
import 'package:game_hub/features/authentication/data/datasources/auth_local_data_source.dart'
    as _i574;
import 'package:game_hub/features/authentication/data/datasources/auth_remote_data_source.dart'
    as _i942;
import 'package:game_hub/features/authentication/data/repositories/auth_repository_impl.dart'
    as _i546;
import 'package:game_hub/features/authentication/domain/repositories/auth_repository.dart'
    as _i1046;
import 'package:game_hub/features/authentication/domain/usecases/login.dart'
    as _i686;
import 'package:game_hub/features/authentication/domain/usecases/register.dart'
    as _i57;
import 'package:game_hub/features/authentication/presentation/bloc/auth_bloc.dart'
    as _i397;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final diModule = _$DiModule();
    gh.singleton<_i689.DioClient>(() => _i689.DioClient());
    await gh.singletonAsync<_i460.SharedPreferences>(
      () => diModule.sharedPreferences,
      preResolve: true,
    );
    gh.singleton<_i942.AuthRemoteDataSource>(
      () => _i942.AuthRemoteDataSourceImpl(gh<_i689.DioClient>()),
    );
    gh.singleton<_i574.AuthLocalDataSource>(
      () => _i574.AuthLocalDataSourceImpl(gh<_i460.SharedPreferences>()),
    );
    gh.singleton<_i1046.AuthRepository>(
      () => _i546.AuthRepositoryImpl(
        gh<_i942.AuthRemoteDataSource>(),
        gh<_i574.AuthLocalDataSource>(),
      ),
    );
    gh.factory<_i686.Login>(() => _i686.Login(gh<_i1046.AuthRepository>()));
    gh.factory<_i57.Register>(() => _i57.Register(gh<_i1046.AuthRepository>()));
    gh.factory<_i397.AuthBloc>(
      () => _i397.AuthBloc(
        loginUseCase: gh<_i686.Login>(),
        registerUseCase: gh<_i57.Register>(),
        authRepository: gh<_i1046.AuthRepository>(),
      ),
    );
    return this;
  }
}

class _$DiModule extends _i865.DiModule {}
