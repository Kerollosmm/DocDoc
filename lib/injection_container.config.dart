// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import 'core/services/excel_service.dart' as _i776;
import 'data/datasources/local/local_attendance_datasource.dart' as _i660;
import 'data/datasources/local/local_student_datasource.dart' as _i249;
import 'data/repositories/attendance_repository_impl.dart' as _i737;
import 'data/repositories/student_repository_impl.dart' as _i947;
import 'data/repositories/sync_repository_impl.dart' as _i942;
import 'domain/repositories/attendance_repository.dart' as _i178;
import 'domain/repositories/student_repository.dart' as _i243;
import 'domain/repositories/sync_repository.dart' as _i193;
import 'features/attendance/presentation/bloc/attendance_bloc.dart' as _i469;
import 'features/students/presentation/bloc/student_bloc.dart' as _i357;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.lazySingleton<_i776.ExcelService>(() => _i776.ExcelService());
    gh.lazySingleton<_i660.LocalAttendanceDataSource>(
        () => _i660.HiveAttendanceDataSource());
    gh.lazySingleton<_i249.LocalStudentDataSource>(
        () => _i249.HiveStudentDataSource());
    gh.lazySingleton<_i193.SyncRepository>(
        () => _i942.SyncRepositoryImpl(gh<_i660.LocalAttendanceDataSource>()));
    gh.lazySingleton<_i178.AttendanceRepository>(
        () => _i737.AttendanceRepositoryImpl(
              gh<_i660.LocalAttendanceDataSource>(),
              gh<_i193.SyncRepository>(),
            ));
    gh.lazySingleton<_i243.StudentRepository>(
        () => _i947.StudentRepositoryImpl(gh<_i249.LocalStudentDataSource>()));
    gh.factory<_i469.AttendanceBloc>(
        () => _i469.AttendanceBloc(gh<_i178.AttendanceRepository>()));
    gh.factory<_i357.StudentBloc>(
        () => _i357.StudentBloc(gh<_i243.StudentRepository>()));
    return this;
  }
}
