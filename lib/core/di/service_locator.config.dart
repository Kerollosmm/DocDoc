// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/attendance/data/datasources/attendance_local_data_source.dart'
    as _i769;
import '../../features/attendance/data/datasources/attendance_remote_data_source.dart'
    as _i680;
import '../../features/attendance/data/repositories/attendance_repository_impl.dart'
    as _i719;
import '../../features/attendance/domain/repositories/attendance_repository.dart'
    as _i477;
import '../../features/attendance/domain/usecases/get_servants_usecase.dart'
    as _i920;
import '../../features/attendance/domain/usecases/mark_attendance_usecase.dart'
    as _i673;
import '../../features/attendance/domain/usecases/sync_attendance_usecase.dart'
    as _i139;
import '../../features/attendance/presentation/bloc/attendance_bloc.dart'
    as _i700;
import '../../features/auth/data/datasources/auth_local_data_source.dart'
    as _i852;
import '../../features/auth/data/datasources/auth_remote_data_source.dart'
    as _i107;
import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i153;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/auth/domain/usecases/check_user_usecase.dart' as _i812;
import '../../features/auth/domain/usecases/login_usecase.dart' as _i188;
import '../../features/auth/domain/usecases/logout_usecase.dart' as _i48;
import '../../features/auth/presentation/bloc/auth_bloc.dart' as _i797;
import '../services/connectivity_service.dart' as _i47;
import '../services/sync_service.dart' as _i979;
import 'register_module.dart' as _i291;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i59.FirebaseAuth>(() => registerModule.firebaseAuth);
    gh.lazySingleton<_i974.FirebaseFirestore>(() => registerModule.firestore);
    gh.lazySingleton<_i895.Connectivity>(() => registerModule.connectivity);
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => registerModule.secureStorage,
    );
    gh.lazySingleton<_i769.AttendanceLocalDataSource>(
      () => _i769.HiveAttendanceDataSource(),
    );
    gh.lazySingleton<_i852.AuthLocalDataSource>(
      () => _i852.HiveAuthDataSource(gh<_i558.FlutterSecureStorage>()),
    );
    gh.lazySingleton<_i680.AttendanceRemoteDataSource>(
      () => _i680.FirestoreAttendanceDataSource(gh<_i974.FirebaseFirestore>()),
    );
    gh.lazySingleton<_i47.ConnectivityService>(
      () => _i47.ConnectivityServiceImpl(gh<_i895.Connectivity>()),
    );
    gh.lazySingleton<_i107.AuthRemoteDataSource>(
      () => _i107.FirebaseAuthDataSource(gh<_i59.FirebaseAuth>()),
    );
    gh.lazySingleton<_i477.AttendanceRepository>(
      () => _i719.AttendanceRepositoryImpl(
        gh<_i769.AttendanceLocalDataSource>(),
        gh<_i680.AttendanceRemoteDataSource>(),
        gh<_i47.ConnectivityService>(),
      ),
    );
    gh.lazySingleton<_i787.AuthRepository>(
      () => _i153.AuthRepositoryImpl(
        gh<_i107.AuthRemoteDataSource>(),
        gh<_i852.AuthLocalDataSource>(),
        gh<_i47.ConnectivityService>(),
        gh<_i974.FirebaseFirestore>(),
      ),
    );
    gh.lazySingleton<_i812.CheckUserUseCase>(
      () => _i812.CheckUserUseCase(gh<_i787.AuthRepository>()),
    );
    gh.lazySingleton<_i188.LoginUseCase>(
      () => _i188.LoginUseCase(gh<_i787.AuthRepository>()),
    );
    gh.lazySingleton<_i48.LogoutUseCase>(
      () => _i48.LogoutUseCase(gh<_i787.AuthRepository>()),
    );
    gh.lazySingleton<_i979.SyncService>(
      () => _i979.SyncService(
        gh<_i47.ConnectivityService>(),
        gh<_i477.AttendanceRepository>(),
      ),
    );
    gh.lazySingleton<_i920.GetServantsUseCase>(
      () => _i920.GetServantsUseCase(gh<_i477.AttendanceRepository>()),
    );
    gh.lazySingleton<_i673.MarkAttendanceUseCase>(
      () => _i673.MarkAttendanceUseCase(gh<_i477.AttendanceRepository>()),
    );
    gh.lazySingleton<_i139.SyncAttendanceUseCase>(
      () => _i139.SyncAttendanceUseCase(gh<_i477.AttendanceRepository>()),
    );
    gh.factory<_i797.AuthBloc>(
      () => _i797.AuthBloc(
        gh<_i188.LoginUseCase>(),
        gh<_i48.LogoutUseCase>(),
        gh<_i812.CheckUserUseCase>(),
      ),
    );
    gh.factory<_i700.AttendanceBloc>(
      () => _i700.AttendanceBloc(
        gh<_i920.GetServantsUseCase>(),
        gh<_i673.MarkAttendanceUseCase>(),
        gh<_i139.SyncAttendanceUseCase>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
