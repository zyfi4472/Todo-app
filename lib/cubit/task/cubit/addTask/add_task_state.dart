part of 'add_task_cubit.dart';

sealed class AddTaskState extends Equatable {
  const AddTaskState();

  @override
  List<Object> get props => [];
}

final class AddTaskInitialState extends AddTaskState {}

final class AddTaskInProgressState extends AddTaskState {}

final class AddTaskSuccessState extends AddTaskState {}

final class AddTaskErrorState extends AddTaskState {}
