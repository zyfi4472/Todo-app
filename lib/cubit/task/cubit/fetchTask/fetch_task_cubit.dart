import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../data/model/task_model.dart';
import '../../../../data/repository/tasks_repo.dart';

part 'fetch_task_state.dart';

class FetchTaskCubit extends Cubit<FetchTaskState> {
  final TaskRepo taskRepo;

  FetchTaskCubit(this.taskRepo) : super(FetchTaskInitial());

  Future<void> fetchTasks() async {
    try {
      print('try block is excuted');

      emit(FetchTaskLoading());

      final tasks = await taskRepo.fetchTasks();

      if (tasks != null) {
        print('tasks not null');

        if (tasks.isEmpty) {
          print('tasks is empty');

          emit(FetchTaskEmpty());
        } else {
          print('tasks loaded');

          emit(FetchTaskLoaded(tasks));
        }
      } else {
        print('tasks is null');

        emit(FetchTaskException('There is some issue with response'));
      }
    } catch (e) {
      print('OnException is excuted');

      emit(FetchTaskException('Internet issue'));
    }

    return;
  }
}
