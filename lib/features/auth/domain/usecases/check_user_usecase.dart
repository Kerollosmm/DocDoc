import 'package:fpdart/fpdart.dart';
import 'package:csms/core/error/failures.dart';
import 'package:csms/features/auth/domain/entities/user_entity.dart';
import 'package:csms/features/auth/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class CheckUserUseCase {
  final AuthRepository repository;

  CheckUserUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call() async {
    return await repository.checkUser();
  }
}
