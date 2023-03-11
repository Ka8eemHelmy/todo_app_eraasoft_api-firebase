import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_shared/model/task/TaskModel.dart';

class TaskWidget extends StatelessWidget {
  TaskModelFireBase task;

  TaskWidget({required this.task, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            task.title ?? 'No Title',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
            ),
          ),
          if (task.description != null)
            Text(
              task.description!,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp, color: Colors.grey.shade400),
            ),
          SizedBox(
            height: 10.h,
          ),
          Row(
            children: [
              if(task.startDate != null)
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    color: Colors.green.shade200,
                  ),
                  child: Text(
                    task.startDate!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              if(task.endDate!= null)
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    color: Colors.red.shade200,
                  ),
                  child: Text(
                    task.endDate!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
