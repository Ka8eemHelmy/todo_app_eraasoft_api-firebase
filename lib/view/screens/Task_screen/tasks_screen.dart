import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:todo_shared/model/task/TaskModel.dart';
import 'package:todo_shared/model/task/task_model.dart';
import 'package:todo_shared/view_model/bloc/task_cubit/task_cubit.dart';
import 'package:todo_shared/view_model/navigation.dart';
import '../../../view_model/bloc/task_cubit/task_state.dart';
import '../../components/task/task_widget.dart';
import 'add_task_screen.dart';
import 'edit_task_screen.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider.value(
        value: TaskCubit.get(context)..getAllTasksFromFireBase(),
        child: BlocConsumer<TaskCubit, TaskState>(
          listener: (context, state) {},
          builder: (context, state) {
            var cubit = TaskCubit.get(context);
            return (cubit.tasksFireBase ?? []).isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Lottie.network(
                          'https://assets5.lottiefiles.com/packages/lf20_rzjlioaj.json',
                          height: 200.h,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          'Add Task ...',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.sp,
                          ),
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.all(12.w),
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        return Material(
                          borderRadius: BorderRadius.circular(12.r),
                          color: Colors.grey,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: InkWell(
                            onTap: () {
                              cubit.changeCurrentTask(index);
                              Navigation.goPush(context, EditTaskScreen());
                            },
                            child: TaskWidget(
                              task: cubit.tasksFireBase[index] ?? TaskModelFireBase(),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => SizedBox(
                        height: 10.h,
                      ),
                      itemCount: cubit.tasksFireBase.length,
                    ),
                  );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigation.goPush(context, AddTaskScreen());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
