import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../data/repository/firebaseAuthRepo/firebase_auth_repo.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  FirebaseAuthRepo firebaseAuthRepo;

  LoginCubit(this.firebaseAuthRepo) : super(LoginInitial());

  Future<User?> login(String email, String password) async {
    try {
      emit(LoginInProgressState());

      final user = await firebaseAuthRepo.signIn(email, password);
      if (user != null) {
        print('user not null');
      }

      emit(LoginSuccessState(user!));
    } catch (e) {
      emit(LoginErrorState());
    }
    return null;
  }
}
