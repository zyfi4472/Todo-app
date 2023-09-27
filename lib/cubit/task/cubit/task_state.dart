part of 'task_cubit.dart';

@immutable
sealed class TaskState extends Equatable {}

final class TaskInitial extends TaskState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

final class TaskLoading extends TaskState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

final class TaskLoaded extends TaskState {
  List<TaskModel> taskList;

  TaskLoaded(this.taskList);

  List<Object?> get props => throw UnimplementedError();

  List<TaskModel> get tasks => taskList;
}

final class TaskEmpty extends TaskState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

final class OnException extends TaskState {
  String text;
  OnException(this.text);
  List<Object?> get props => throw UnimplementedError();
}
