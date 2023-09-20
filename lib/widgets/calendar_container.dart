import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CalenderContainerWidget extends StatelessWidget {
  const CalenderContainerWidget({
    super.key,
    required this.selectedDate,
  });

  final DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: const Color(0XFFFFFFFF),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), // Shadow color
            blurRadius: 5, // Blur radius
            offset: const Offset(0, 3), // Offset in the (x, y) direction
          ),
        ],
        border: Border.all(
          color: const Color(0XFFCECED4), // Choose your border color
          width: 1.0, // Choose your border width
        ),
      ),
      width: 150.w,
      height: 30.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              "${selectedDate.toLocal()}".split(' ')[0],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: Icon(Icons.calendar_month),
          ),
        ],
      ),
    );
  }
}
