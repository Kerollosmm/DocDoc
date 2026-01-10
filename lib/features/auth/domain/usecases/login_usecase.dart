import 'package:fpdart/fpdart.dart';
import 'package:csms/core/error/failures.dart';
import 'package:csms/features/auth/domain/entities/user_entity.dart';
import 'package:csms/features/auth/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call(String email, String password) async {
    return await repository.login(email, password);
  }
}
