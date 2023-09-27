import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:todoey_app/data/model/task_model.dart';
import 'package:todoey_app/data/repository/tasks_repo.dart';

part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final TaskRepo taskRepo;
  TaskCubit(this.taskRepo) : super(TaskInitial());

  Future<void> fetchTasks() async {
    try {
      print('try block is excuted');

      emit(TaskLoading());

      final tasks = await taskRepo.fetchTasks();

      if (tasks != null) {
        print('tasks not null');

        if (tasks.isEmpty) {
          print('tasks is empty');

          emit(TaskEmpty());
        } else {
          print('tasks loaded');

          emit(TaskLoaded(tasks));
        }
      } else {
        print('tasks is null');

        emit(OnException('There is some issue with response'));
      }
    } catch (e) {
      print('OnException is excuted');

      emit(OnException('Internet issue'));
    }

    return;
  }
}
