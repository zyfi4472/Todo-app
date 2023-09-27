import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todoey_app/views/widgets/task_detail_item.dart';

class TaskTile extends StatelessWidget {
  // Properties to store task information
  // final bool? isChecked;
  final String taskTitle;
  final String taskDescription;
  final String taskPriority;
  final String taskDeadline;

  // Callback functions for checkbox and long press actions
  final Function(bool?) checkboxCallback;
  final Function() longPressCallback;

  // Constructor to initialize the TaskTile
  const TaskTile({
    super.key,
    // required this.isChecked,
    required this.taskTitle,
    required this.taskDeadline,
    required this.taskPriority,
    required this.taskDescription,
    required this.checkboxCallback,
    required this.longPressCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 7,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.r),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Task Title
            Text(
              'Title:',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                Text(
                  taskTitle,
                  style: TextStyle(
                    fontSize: 14.sp,
                    // decoration: isChecked ? TextDecoration.lineThrough : null,
                  ),
                ),
                const Spacer(),
                Checkbox(
                  activeColor: Colors.lightBlueAccent,
                  value: false,
                  onChanged: checkboxCallback,
                ),
              ],
            ),
            SizedBox(height: 5.h),

            // Task Description
            TaskDetailItem(
              heading: 'Description:',
              text: taskDescription,
              // isChecked: isChecked,
            ),
            SizedBox(height: 10.h),

            // Task Priority
            TaskDetailItem(
              heading: 'Priority:',
              text: taskPriority,
              // isChecked: isChecked,
            ),
            SizedBox(height: 10.h),

            // Task Priority
            TaskDetailItem(
              heading: 'Deadline:',
              text: taskDeadline,
              // isChecked: isChecked,
            ),
          ],
        ),
      ),
    );

    // ListTile(
    //   onLongPress: longPressCallback,
    //   title: Text(
    //     taskTitle,
    //     style: TextStyle(
    //         decoration: isChecked ? TextDecoration.lineThrough : null),
    //   ),
    //   trailing: Checkbox(
    //     activeColor: Colors.lightBlueAccent,
    //     value: isChecked,
    //     onChanged: checkboxCallback,
    //   ),
    // );
  }
}
