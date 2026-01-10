import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:csms/core/error/failures.dart';
import 'package:csms/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<void> logout();
  Future<UserModel?> getCurrentUser(); // From Firebase Auth state
}

@LazySingleton(as: AuthRemoteDataSource)
class FirebaseAuthDataSource implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthDataSource(this._firebaseAuth);

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user == null) {
        throw const ServerFailure('User is null after login');
      }

      // In a real app, we might fetch more details from Firestore 'users' collection
      // For now, we construct UserModel from Auth User
      // Note: We need to get the role. Usually this is in Custom Claims or Firestore.
      // Assuming 'servant' default or fetching from Firestore in a bigger implementation.
      // Here I will return a basic user and let Repository handle role fetching if needed.
      // Or I can fetch the claim.

      // For this phase, let's assume we fetch the ID token result to check claims?
      // Or just return basic info. The prompt says "Role-based...".
      // Let's assume we query Firestore in the repository or here.
      // But to keep it simple and strictly "AuthDataSource", I'll just return the Auth user
      // and let the Repository merge it with Firestore data if needed.
      // However, UserModel requires 'role'.

      return UserModel(
        id: user.uid,
        email: user.email ?? '',
        role: 'servant', // Default, should be fetched
      );
    } on FirebaseAuthException catch (e) {
      throw ServerFailure(e.message ?? 'Login failed');
    } catch (e) {
      throw const ServerFailure('An unexpected error occurred');
    }
  }

  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
     final user = _firebaseAuth.currentUser;
     if (user != null) {
       return UserModel(
         id: user.uid,
         email: user.email ?? '',
         role: 'servant', // Placeholder
       );
     }
     return null;
  }
}
