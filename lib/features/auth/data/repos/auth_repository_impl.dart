import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doc_app/core/config/hive_boxes_config.dart';
import 'package:doc_app/core/error/failures.dart';
import 'package:doc_app/features/auth/domain/entities/user_entity.dart';
import 'package:doc_app/features/auth/domain/repos/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final Box _authBox;

  AuthRepositoryImpl(this._firebaseAuth, this._firestore, this._authBox);

  @override
  Future<Either<Failure, UserEntity>> login(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        return Left(AuthFailure('User not found'));
      }

      // Fetch user role from Firestore
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (!userDoc.exists) {
         return Left(AuthFailure('User profile not found in database'));
      }

      final userData = userDoc.data()!;
      final userEntity = UserEntity(
        uid: user.uid,
        email: user.email ?? '',
        role: userData['role'] ?? 'student',
        name: userData['name'],
      );

      // Cache user locally
      await _authBox.put('current_user', {
        'uid': userEntity.uid,
        'email': userEntity.email,
        'role': userEntity.role,
        'name': userEntity.name,
      });

      return Right(userEntity);

    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(e.message ?? 'Authentication failed'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _firebaseAuth.signOut();
      await _authBox.delete('current_user');
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    // Try to get from Cache first
    final cachedUser = _authBox.get('current_user');
    if (cachedUser != null) {
      return Right(UserEntity(
        uid: cachedUser['uid'],
        email: cachedUser['email'],
        role: cachedUser['role'],
        name: cachedUser['name'],
      ));
    }

    // If not in cache, check firebase
    final user = _firebaseAuth.currentUser;
    if (user != null) {
       // Logic to fetch from firestore again if needed, or just return basic info
       // For now, let's assume we need to re-login to get full profile if cache is empty
       return Left(AuthFailure('Session expired'));
    }

    return Left(AuthFailure('No user logged in'));
  }
}
