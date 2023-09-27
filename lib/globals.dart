String selectedValue = 'Medium'; // Initialize with a valid option
const String isLoggedInKey = 'isLogin';
const String userIdKey = 'userId';
const String isAdminKey = 'isAdmin';
late bool isLoggedInGlobal;
late bool isAdminGlobal;
late String userIdGlobal;
// ignore: prefer_typing_uninitialized_variables
late var sharedPrefGlobal;



// //TASK CUBIT

// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:meta/meta.dart';
// import 'package:todoey_app/data/model/task_model.dart';
// import 'package:todoey_app/data/repository/tasks_repo.dart';

// part 'task_state.dart';

// class TaskCubit extends Cubit<TaskState> {
//   final TaskRepo taskRepo;
//   TaskCubit(this.taskRepo) : super(TaskInitial());

//   Future<void> fetchTasks() async {
//     try {
//       print('try block is excuted');

//       emit(TaskLoading());

//       final tasks = await taskRepo.fetchTasks();

//       if (tasks != null) {
//         print('tasks not null');

//         if (tasks.isEmpty) {
//           print('tasks is empty');

//           emit(TaskEmpty());
//         } else {
//           print('tasks loaded');

//           emit(TaskLoaded(tasks));
//         }
//       } else {
//         print('tasks is null');

//         emit(OnException('There is some issue with response'));
//       }
//     } catch (e) {
//       print('OnException is excuted');

//       emit(OnException('Internet issue'));
//     }

//     return;
//   }
// }


// // TASK STATE

// part of 'task_cubit.dart';

// @immutable
// sealed class TaskState extends Equatable {}

// final class TaskInitial extends TaskState {
//   @override
//   // TODO: implement props
//   List<Object?> get props => throw UnimplementedError();
// }

// final class TaskLoading extends TaskState {
//   @override
//   // TODO: implement props
//   List<Object?> get props => throw UnimplementedError();
// }

// final class TaskLoaded extends TaskState {
//   List<TaskModel> taskList;

//   TaskLoaded(this.taskList);

//   List<Object?> get props => throw UnimplementedError();

//   List<TaskModel> get tasks => taskList;
// }

// final class TaskEmpty extends TaskState {
//   @override
//   // TODO: implement props
//   List<Object?> get props => throw UnimplementedError();
// }

// final class OnException extends TaskState {
//   String text;
//   OnException(this.text);
//   List<Object?> get props => throw UnimplementedError();
// }
// }