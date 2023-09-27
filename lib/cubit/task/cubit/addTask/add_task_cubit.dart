// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '../../../../data/model/task_model.dart';
import '../../../../data/repository/taskRepo/tasks_repo.dart';

part 'add_task_state.dart';

class AddTaskCubit extends Cubit<AddTaskState> {
  TaskRepo taskRepo;

  AddTaskCubit(this.taskRepo) : super(AddTaskInitialState());

  Future<void> addTask(String newTaskTitle, String priority, String deadline,
      String description, DocumentReference userDocReference) async {
    try {
      emit(
          AddTaskInProgressState()); // Emit a loading state while the task is being added.

      final task = TaskModel(
        name: newTaskTitle,
        deadline: deadline,
        priority: priority,
        description: description,
      );
      await taskRepo.addTaskToFirestore(task, userDocReference);

      emit(
          AddTaskSuccessState()); // Emit a success state when the task is added successfully.
    } catch (e) {
      emit(AddTaskErrorState(
          '$e')); // Emit an error state if an exception occurs.
    }
  }
}
