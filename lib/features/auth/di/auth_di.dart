import 'package:doc_app/core/config/hive_boxes_config.dart';
import 'package:doc_app/features/auth/data/repos/auth_repository_impl.dart';
import 'package:doc_app/features/auth/domain/repos/auth_repository.dart';
import 'package:doc_app/features/auth/presentation/logic/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

final getIt = GetIt.instance;

void setupAuthDependencies() {
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
    getIt(),
    getIt(),
    Hive.box(HiveBoxesConfig.authBox),
  ));

  getIt.registerFactory(() => AuthBloc(getIt()));
}
