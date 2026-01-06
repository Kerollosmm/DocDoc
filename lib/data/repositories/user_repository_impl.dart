import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/role.dart';
import '../../domain/repositories/user_repository.dart';

@LazySingleton(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  final FirebaseFirestore _firestore;

  UserRepositoryImpl(this._firestore);

  @override
  Future<Either<Failure, List<User>>> getServants() async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'servant')
          .get();

      final servants = snapshot.docs.map((doc) {
        final data = doc.data();
        return User(
          id: doc.id,
          email: data['email'] ?? '',
          name: data['name'] ?? '',
          role: UserRole.servant,
          grade: data['grade'],
        );
      }).toList();

      return Right(servants);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateServant(User user) async {
    try {
      await _firestore.collection('users').doc(user.id).update({
        'name': user.name,
        'grade': user.grade,
      });
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
