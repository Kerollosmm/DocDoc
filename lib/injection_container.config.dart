// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import 'data/repositories/attendance_repository_impl.dart' as _i737;
import 'data/repositories/student_repository_impl.dart' as _i947;
import 'domain/repositories/attendance_repository.dart' as _i178;
import 'domain/repositories/student_repository.dart' as _i243;
import 'features/student_list/presentation/bloc/student_bloc.dart' as _i965;

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
    gh.lazySingleton<_i243.StudentRepository>(
        () => _i947.StudentRepositoryImpl());
    gh.lazySingleton<_i178.AttendanceRepository>(
        () => _i737.AttendanceRepositoryImpl());
    gh.factory<_i965.StudentBloc>(
        () => _i965.StudentBloc(gh<_i243.StudentRepository>()));
    return this;
  }
}
