import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final firebase_auth.FirebaseAuth _firebaseAuth;

  AuthRepositoryImpl(this._remoteDataSource, this._firebaseAuth);

  @override
  Future<Either<Failure, User>> signIn(String email, String password) async {
    try {
      final user = await _remoteDataSource.signIn(email, password);
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _remoteDataSource.signOut();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final user = await _remoteDataSource.getCurrentUser();
      return Right(user);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String?>> getIdToken({bool forceRefresh = false}) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        return const Left(ServerFailure('No user logged in'));
      }
      final token = await user.getIdToken(forceRefresh);
      return Right(token);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
