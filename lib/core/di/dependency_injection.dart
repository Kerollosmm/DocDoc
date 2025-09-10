import 'package:doc_app/core/networking/api_service.dart';
import 'package:doc_app/core/networking/dio_factory.dart';
import 'package:doc_app/features/login/data/repos/login_repo.dart';
import 'package:doc_app/features/login/logic/cubit/login_cubit.dart';
import 'package:doc_app/features/sign_up/data/repos/sign_up_repo.dart';
import 'package:doc_app/features/sign_up/logic/sign_up_cubit.dart'; // Add this import
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

final getIt = GetIt.instance;

Future<void> setUpGetIt() async {
  //Dio & ApiServices
  Dio dio = DioFactory.getDio();
  getIt.registerLazySingleton<ApiService>(() => ApiService(dio));

  //login
  getIt.registerLazySingleton<LoginRepo>(() => LoginRepo(getIt()));
  getIt.registerFactory<LoginCubit>(() => LoginCubit(getIt()));

  //SignUp
  getIt.registerLazySingleton<SignupRepo>(() => SignupRepo(getIt()));
  // This is the line you need to add to register your cubit
  getIt.registerFactory<SignupCubit>(() => SignupCubit(getIt()));
}