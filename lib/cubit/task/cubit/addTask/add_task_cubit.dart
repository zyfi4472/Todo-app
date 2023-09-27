import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:todoey_app/data/repository/tasks_repo.dart';
import 'package:todoey_app/data/model/task_model.dart'; // Import your TaskModel

part 'add_task_state.dart';

class AddTaskCubit extends Cubit<AddTaskState> {
  TaskRepo taskRepo;

  AddTaskCubit(this.taskRepo) : super(AddTaskInitialState());

  Future<void> addTask(TaskModel task, DocumentReference userReference) async {
    try {
      emit(
          AddTaskInProgressState()); // Emit a loading state while the task is being added.

      await taskRepo.addTaskToFirestore(task, userReference);

      emit(
          AddTaskSuccessState()); // Emit a success state when the task is added successfully.
    } catch (e) {
      emit(AddTaskErrorState()); // Emit an error state if an exception occurs.
    }
  }
}
