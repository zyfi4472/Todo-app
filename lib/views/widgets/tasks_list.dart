import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todoey_app/data/model/task_model.dart';
import 'package:todoey_app/views/widgets/task_tile.dart';

import '../../cubit/task/cubit/fetchTask/fetch_task_cubit.dart';

class TasksList extends StatelessWidget {
  const TasksList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchTaskCubit, FetchTaskState>(
      builder: (context, state) {
        if (state is FetchTaskLoading) {
          // Show a loading indicator or return a loading widget
          return const CircularProgressIndicator();
        } else if (state is FetchTaskEmpty) {
          return const Center(
            child: Text(
              'Task list is empty',
              style: TextStyle(color: Colors.red),
            ),
          );
        } else if (state is FetchTaskLoaded) {
          // Access the list of tasks from the state
          final List<TaskModel> tasks = state.tasks;

          return Column(
            children: <Widget>[
              SizedBox(height: 15.h),
              Text(
                'My Tasks',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    final task = tasks[index]; // Use tasks from the state
                    return TaskTile(
                      taskTitle: task.name,
                      taskDescription: task.description,
                      taskDeadline: task.deadline,
                      taskPriority: task.priority,
                      // isChecked: task.isDone,
                      checkboxCallback: (checkboxState) {
                        // Add checkbox logic here
                      },
                      longPressCallback: () {
                        // Add long press logic here
                      },
                    );
                  },
                  itemCount: tasks.length, // Use tasks from the state
                ),
              ),
            ],
          );
        }
        return Container();
      },
    );
  }
}
