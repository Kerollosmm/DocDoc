import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csms/core/error/failures.dart';
import 'package:csms/features/auth/data/models/user_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:csms/core/services/connectivity_service.dart';
import 'package:csms/features/auth/domain/entities/user_entity.dart';
import 'package:csms/features/auth/domain/repositories/auth_repository.dart';
import 'package:csms/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:csms/features/auth/data/datasources/auth_remote_data_source.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final ConnectivityService _connectivityService;
  final FirebaseFirestore _firestore;

  AuthRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._connectivityService,
    this._firestore,
  );

  @override
  Future<Either<Failure, UserEntity>> login(String email, String password) async {
    if (await _connectivityService.isConnected) {
      try {
        final userModel = await _remoteDataSource.login(email, password);

        // Fetch real role from Firestore 'users' collection
        final userDoc = await _firestore.collection('users').doc(userModel.id).get();
        String role = 'servant';
        if (userDoc.exists) {
           final data = userDoc.data();
           role = data?['role'] ?? 'servant';
        }

        final fullUser = UserModel(id: userModel.id, email: userModel.email, role: role);

        await _localDataSource.saveUser(fullUser);
        // Token handling logic if needed, e.g., await _localDataSource.saveToken(token);

        return Right(fullUser);
      } catch (e) {
        if (e is Failure) return Left(e);
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(OfflineFailure('Cannot login while offline.'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      if (await _connectivityService.isConnected) {
        await _remoteDataSource.logout();
      }
      await _localDataSource.clearUser();
      await _localDataSource.clearToken();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> checkUser() async {
    try {
      final localUser = await _localDataSource.getUser();
      if (localUser != null) {
        // Optimistically return local user
        return Right(localUser);
      }

      // If no local user, check remote if online (auto-login?)
      // Usually checkUser is for session restore. If no local session, user is logged out.

      return const Left(AuthFailure('No user logged in'));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
