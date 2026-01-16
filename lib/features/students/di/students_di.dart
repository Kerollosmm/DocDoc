import 'package:doc_app/core/config/hive_boxes_config.dart';
import 'package:doc_app/features/students/data/repos/students_repository_impl.dart';
import 'package:doc_app/features/students/domain/repos/students_repository.dart';
import 'package:doc_app/features/students/presentation/logic/students_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

final getIt = GetIt.instance;

void setupStudentsDependencies() {
  getIt.registerLazySingleton<StudentsRepository>(() => StudentsRepositoryImpl(
    getIt(),
    Hive.box(HiveBoxesConfig.studentsBox),
  ));

  getIt.registerFactory(() => StudentsBloc(getIt()));
}
