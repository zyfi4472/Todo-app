// ignore_for_file: must_be_immutable

part of 'fetch_task_cubit.dart';

sealed class FetchTaskState extends Equatable {
  const FetchTaskState();

  @override
  List<Object> get props => [];
}

final class FetchTaskInitial extends FetchTaskState {}

final class FetchTaskLoading extends FetchTaskState {}

final class FetchTaskLoaded extends FetchTaskState {
  List<TaskModel> taskList;

  FetchTaskLoaded(this.taskList);

  List<TaskModel> get tasks => taskList;
}

final class FetchTaskEmpty extends FetchTaskState {}

final class FetchTaskException extends FetchTaskState {
  String text;
  FetchTaskException(this.text);
}
