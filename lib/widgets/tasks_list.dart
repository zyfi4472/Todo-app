import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:todoey_app/widgets/task_tile.dart';
import '../models/task_data.dart';

class TasksList extends StatelessWidget {
  const TasksList({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskData>(
      builder: (context, taskData, child) {
        return Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
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
                  final task = taskData.tasks[index];
                  return TaskTile(
                    taskTitle: task.name,
                    taskDescription: task.description,
                    taskDeadline: task.deadline,
                    taskPriority: task.priority,
                    isChecked: task.isDone,
                    checkboxCallback: (checkboxState) {
                      taskData.updateTask(task);
                    },
                    longPressCallback: () {
                      taskData.deleteTask(task);
                    },
                  );
                },
                itemCount: taskData.taskCount,
              ),
            ),
          ],
        );
      },
    );
  }
}
