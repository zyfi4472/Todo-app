part of 'create_user_cubit.dart';

sealed class CreateUserState extends Equatable {
  const CreateUserState();

  @override
  List<Object> get props => [];
}

final class CreateUserInitial extends CreateUserState {}

final class CreateUserInProgress extends CreateUserState {}

final class CreateUserSuccess extends CreateUserState {
  final User user;
  const CreateUserSuccess(this.user);

  @override
  List<Object> get props => [user];
}

final class CreateUserError extends CreateUserState {}
