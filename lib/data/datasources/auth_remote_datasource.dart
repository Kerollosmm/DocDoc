import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import '../../core/error/exceptions.dart';
import '../../domain/entities/user.dart';

abstract class AuthRemoteDataSource {
  Future<User> signIn(String email, String password);
  Future<void> signOut();
  Future<User?> getCurrentUser();
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRemoteDataSourceImpl(this._firebaseAuth, this._firestore);

  @override
  Future<User> signIn(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user!.uid;
      final userDoc = await _firestore.collection('users').doc(uid).get();

      if (!userDoc.exists) {
        throw ServerException('User data not found in database');
      }

      final data = userDoc.data()!;
      return _mapToUser(uid, userCredential.user!.email!, data);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw ServerException(e.message ?? 'Authentication failed');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<User?> getCurrentUser() async {
    final currentUser = _firebaseAuth.currentUser;
    if (currentUser == null) return null;

    try {
      final userDoc = await _firestore.collection('users').doc(currentUser.uid).get();
      if (!userDoc.exists) return null;

      return _mapToUser(currentUser.uid, currentUser.email!, userDoc.data()!);
    } catch (e) {
      return null;
    }
  }

  User _mapToUser(String uid, String email, Map<String, dynamic> data) {
    return User(
      id: uid,
      email: email,
      name: data['name'] ?? '',
      role: (data['role'] == 'admin') ? UserRole.admin : UserRole.servant,
      grade: data['grade'],
    );
  }
}
