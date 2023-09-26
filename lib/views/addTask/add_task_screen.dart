import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:todoey_app/cubit/task_data.dart';
import 'package:todoey_app/globals.dart';
import 'package:todoey_app/widgets/calendar_container.dart';
import 'package:todoey_app/widgets/priority_dropdown.dart';

class AddTaskScreen extends StatefulWidget {
  final DocumentReference userDocReference;

  const AddTaskScreen({super.key, required this.userDocReference});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final user = FirebaseAuth.instance.currentUser;
  DateTime taskDeadline = DateTime.now();
  late String taskTitle, taskDescription;
  TextEditingController newTaskTitleController = TextEditingController();
  TextEditingController? newTaskDescriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff757575),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.0.r),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Add Task',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30.0.sp,
                color: Colors.lightBlueAccent,
              ),
            ),
            TextField(
              autofocus: true,
              textAlign: TextAlign.center,
              controller: newTaskTitleController,
              decoration: const InputDecoration(
                hintText: 'Task Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15.h),
            TextField(
              autofocus: true,
              textAlign: TextAlign.center,
              controller: newTaskDescriptionController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Task Description',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                Text(
                  'Task deadline : ',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                _buildDateButton(
                  onPressed: () => _selectTaskDeadline(context),
                  selectedDate: taskDeadline,
                ),
              ],
            ),
            SizedBox(height: 15.h),
            Row(
              children: [
                Text(
                  'Task Priority  : ',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                // Use the dropdown widget instance here
                const MyDropdownWidget(),
              ],
            ),
            SizedBox(height: 15.h),
            TextButton(
              onPressed: () async {
                // Get text from controllers
                taskTitle = newTaskTitleController.text;
                taskDescription = newTaskDescriptionController!.text;

                // Add the task to the provider
                Provider.of<TaskData>(context, listen: false).addTask(
                  taskTitle,
                  selectedValue,
                  taskDeadline.toUtc().toString(),
                  taskDescription,
                  widget.userDocReference,
                );
                // Navigate back to the previous screen
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.lightBlueAccent,
              ),
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget to build the date button
  Widget _buildDateButton(
      {required VoidCallback onPressed, required DateTime selectedDate}) {
    return TextButton(
      onPressed: onPressed,
      child: CalenderContainerWidget(selectedDate: selectedDate),
    );
  }

  // Function to handle date selection
  Future<void> _selectTaskDeadline(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: taskDeadline,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != taskDeadline) {
      setState(() {
        taskDeadline = picked;
      });
    }
  }
}
