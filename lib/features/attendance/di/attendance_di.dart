import 'package:doc_app/core/config/hive_boxes_config.dart';
import 'package:doc_app/features/attendance/data/repos/attendance_repository_impl.dart';
import 'package:doc_app/features/attendance/domain/repos/attendance_repository.dart';
import 'package:doc_app/features/attendance/presentation/logic/attendance_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

final getIt = GetIt.instance;

void setupAttendanceDependencies() {
  getIt.registerLazySingleton<AttendanceRepository>(() => AttendanceRepositoryImpl(
    getIt(),
    Hive.box(HiveBoxesConfig.attendanceBox),
  ));

  getIt.registerFactory(() => AttendanceBloc(getIt()));
}
