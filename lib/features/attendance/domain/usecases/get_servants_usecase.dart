import 'package:fpdart/fpdart.dart';
import 'package:csms/core/error/failures.dart';
import 'package:csms/features/attendance/domain/entities/servant_entity.dart';
import 'package:csms/features/attendance/domain/repositories/attendance_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetServantsUseCase {
  final AttendanceRepository repository;

  GetServantsUseCase(this.repository);

  Future<Either<Failure, List<ServantEntity>>> call() async {
    return await repository.getServants();
  }
}
