part of 'login_cubit.dart';

sealed class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

final class LoginInitial extends LoginState {}

final class LoginInProgressState extends LoginState {}

final class LoginSuccessState extends LoginState {
  final User user;
  const LoginSuccessState(this.user);
  @override
  List<Object> get props => [user];
}

final class LoginErrorState extends LoginState {}
