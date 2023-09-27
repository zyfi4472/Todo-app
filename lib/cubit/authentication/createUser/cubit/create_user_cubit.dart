import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todoey_app/data/repository/firebaseAuthRepo/firebase_auth_repo.dart';

import '../../../../views/widgets/flutter_toast.dart';

part 'create_user_state.dart';

class CreateUserCubit extends Cubit<CreateUserState> {
  FirebaseAuthRepo firebaseAuthRepo;
  CreateUserCubit(this.firebaseAuthRepo) : super(CreateUserInitial());

  Future<User?> createUser(String email, String password, String name) async {
    try {
      emit(CreateUserInProgress());
      final user = await firebaseAuthRepo.CreateUser(email, password, name);
      showFlutterToast('User created successfully');
      emit(CreateUserSuccess(user!));
    } catch (e) {
      showFlutterToast("Sign-up failed : $e");
      emit(CreateUserError());
    }
    return null;
  }
}
