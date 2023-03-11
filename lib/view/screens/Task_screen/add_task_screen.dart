import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_shared/view_model/bloc/task_cubit/task_cubit.dart';
import 'package:todo_shared/view_model/bloc/task_cubit/task_state.dart';

class AddTaskScreen extends StatelessWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TaskCubit.get(context).clearControllers();
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task'),
      ),
      body: BlocConsumer<TaskCubit, TaskState>(
        listener: (context, state) {
          if(state is AddTaskSuccessState){
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          var cubit = TaskCubit.get(context);
          return Padding(
            padding: EdgeInsets.all(12.w),
            child: Form(
              key: cubit.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Title',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp,
                    ),
                  ),
                  TextFormField(
                    controller: cubit.titleController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please, Enter Your Title";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    'Description',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp,
                    ),
                  ),
                  TextFormField(
                    controller: cubit.descriptionController,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    'Start Date',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp,
                    ),
                  ),
                  TextFormField(
                    controller: cubit.startDateController,
                    keyboardType: TextInputType.none,
                    onTap: () {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2021),
                        lastDate: DateTime(2025),
                      ).then(
                        (value) => cubit.startDateController.text = value?.toString() ?? '',
                      );
                    },
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    'Ednd Date',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp,
                    ),
                  ),
                  TextFormField(
                    controller: cubit.endDateController,
                    keyboardType: TextInputType.none,
                    onTap: () {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2021),
                        lastDate: DateTime(2025),
                      ).then(
                            (value) => cubit.endDateController.text = value?.toString() ?? '',
                      );
                    },
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (cubit.formKey.currentState!.validate()) {
                          // cubit.addNewTask();
                          cubit.addTaskToFireBase();
                        }
                      },
                      child: Text(
                        'Submit',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
