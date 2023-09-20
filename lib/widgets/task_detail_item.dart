import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TaskDetailItem extends StatelessWidget {
  const TaskDetailItem({
    super.key,
    required this.text,
    required this.heading,
    required this.isChecked,
  });

  final String text;
  final bool isChecked;
  final String heading;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5.h),
        Text(
          text,
          style: TextStyle(
            fontSize: 14.sp,
            decoration: isChecked ? TextDecoration.lineThrough : null,
          ),
        ),
      ],
    );
  }
}
