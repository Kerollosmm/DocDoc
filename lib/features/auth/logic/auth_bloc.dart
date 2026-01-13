import 'package:bloc/bloc.dart';
import 'package:doc_app/core/models/user_role.dart';

sealed class AuthEvent {
  const AuthEvent();
}

class AppStarted extends AuthEvent {
  const AppStarted();
}

class LoginRequested extends AuthEvent {
  final UserRole role;

  const LoginRequested(this.role);
}

class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}

sealed class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class Authenticated extends AuthState {
  final UserRole role;

  const Authenticated(this.role);
}

class Unauthenticated extends AuthState {
  const Unauthenticated();
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthInitial()) {
    on<AppStarted>((event, emit) => emit(const Unauthenticated()));
    on<LoginRequested>((event, emit) => emit(Authenticated(event.role)));
    on<LogoutRequested>((event, emit) => emit(const Unauthenticated()));
  }
}
