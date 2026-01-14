import 'package:doc_app/core/error/failures.dart';
import 'package:doc_app/features/auth/domain/entities/user_entity.dart';
import 'package:doc_app/features/auth/domain/repos/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_state.dart';

class AuthBloc extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    final result = await _authRepository.login(email, password);
    result.fold(
      (failure) => emit(AuthFailureState(failure.message)),
      (user) => emit(AuthSuccess(user)),
    );
  }

  Future<void> checkAuthStatus() async {
    final result = await _authRepository.getCurrentUser();
    result.fold(
      (failure) => emit(AuthInitial()),
      (user) => emit(AuthSuccess(user)),
    );
  }

  Future<void> logout() async {
    await _authRepository.logout();
    emit(AuthInitial());
  }
}
