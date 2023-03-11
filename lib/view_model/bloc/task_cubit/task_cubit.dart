import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo_shared/model/task/TaskModel.dart';
import 'package:todo_shared/view_model/bloc/task_cubit/task_state.dart';
import 'package:todo_shared/view_model/firebase_collections/collection.dart' as kareem;
import 'package:todo_shared/view_model/servises/local/shared_preference.dart';
import 'package:todo_shared/view_model/servises/network/DioHelper.dart';
import '../../../model/task/task_model.dart';
import '../../servises/local/shared_keys.dart';
import '../../servises/network/endPoints.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit() : super(TaskInitState());

  static TaskCubit get(context) => BlocProvider.of<TaskCubit>(context);

  TaskModel? taskModel;

  void getAllTasks() {
    emit(GetAllTasksLoadingState());
    DioHelper.get(
      endPoint: tasks,
      token: SharedPreference.get(SharedKeys.userToken),
    ).then((value) {
      print(value?.data);
      taskModel = TaskModel.fromJson(value?.data);
      emit(GetAllTasksSuccessState());
    }).catchError((onError) {
      if (onError is DioError) {
        print(onError.response?.data);
        Fluttertoast.showToast(
          msg: "Error in Get All Tasks ${onError.response?.data.toString()}",
          // toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          // timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          // textColor: Colors.white,
          // fontSize: 16.0
        );
        emit(GetAllTasksErrorState());
      }
    });
  }

  List<TaskModelFireBase> tasksFireBase = [];

  void getAllTasksFromFireBase(){
    emit(GetAllTasksLoadingState());
    FirebaseFirestore.instance.collection(kareem.task).where('title',isGreaterThan: 100).orderBy('score').snapshots().listen((value) {
      tasksFireBase = [];
      value.docs.forEach((element) {
        TaskModelFireBase currentTask = TaskModelFireBase.fromJson(element.data());
        currentTask.id = element.id;
        tasksFireBase.add(currentTask);
        print(element.data());
      });
      emit(GetAllTasksSuccessState());
    }).onError((error){
      print('Get All Tasks FireBase Error $error');
      emit(GetAllTasksErrorState());
    });
  }

  void updateTaskFireBase(){
    emit(EditTaskLoadingState());
    TaskModelFireBase task = TaskModelFireBase(
      title: titleController.text,
      description: descriptionController.text,
      startDate: startDateController.text,
      endDate: endDateController.text,
    );
    FirebaseFirestore.instance.collection(kareem.task).doc(tasksFireBase[currentTaskIndex].id).update(task.toJson()).then((value) {
      print('Edit Task Successfully');
      emit(EditTaskSuccessState());
    }).catchError((onError){
      print('Update Task Error $onError');
      emit(EditTaskErrorState());
    });
  }

  void deleteTaskFireBase (){
    emit(DeleteTaskLoadingState());
    FirebaseFirestore.instance.collection(kareem.task).doc(tasksFireBase[currentTaskIndex].id).delete().then((value){
      print('Delete Task Successfully');
      emit(DeleteTaskSuccessState());
    }).catchError((onError){
      print('Delete Task Error $onError');
      emit(DeleteTaskErrorState());
    });
  }

  Task? task;

  void addNewTask() {
    emit(AddTaskLoadingState());
    DioHelper.post(
      endPoint: tasks,
      token: SharedPreference.get(SharedKeys.userToken),
      data: {
        'title': titleController.text,
        'description': descriptionController.text,
        'start_date': startDateController.text,
        'end_date': endDateController.text,
      },
    ).then((value) {
      print(value.data);
      task = Task.fromJson(value.data['response']);
      if (task != null) {
        taskModel?.tasks?.add(task!);
      }
      emit(AddTaskSuccessState());
    }).catchError((onError) {
      if (onError is DioError) {
        print(onError.response?.data);
        Fluttertoast.showToast(
          msg: "Error in Get All Tasks ${onError.response?.data.toString()}",
          // toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          // timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          // textColor: Colors.white,
          // fontSize: 16.0
        );
        emit(AddTaskErrorState());
      }
    });
  }

  void addTaskToFireBase(){
    TaskModelFireBase task = TaskModelFireBase(
      title: titleController.text,
      description: descriptionController.text,
      startDate: startDateController.text,
      endDate: endDateController.text,
    );
    emit(AddTaskLoadingState());
    FirebaseFirestore.instance.collection('tasks').add(task.toJson()).then((value){
      print('Add Task Successfully');
      emit(AddTaskSuccessState());
    }).catchError((onError){
      print('Add Task Error $onError');
      emit(AddTaskErrorState());
    });
  }

  void editTask() {
    emit(EditTaskLoadingState());
    DioHelper.post(
      endPoint: '$tasks/${taskModel?.tasks?[currentTaskIndex].id}',
      token: SharedPreference.get(SharedKeys.userToken),
      data: {
        'title': titleController.text,
        'description': descriptionController.text,
        'start_date': startDateController.text,
        'end_date': endDateController.text,
        '_method': 'PUT',
        'status': 'in_progress',
      },
    ).then((value) {
      print(value.data);
      task = Task.fromJson(value.data['response']);
      if (task != null) {
        taskModel?.tasks?[currentTaskIndex] = task!;
      }
      emit(EditTaskSuccessState());
    }).catchError((onError) {
      if (onError is DioError) {
        print(onError.response?.data);
        Fluttertoast.showToast(
          msg: "Error in Get All Tasks ${onError.response?.data.toString()}",
          // toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          // timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          // textColor: Colors.white,
          // fontSize: 16.0
        );
        emit(EditTaskErrorState());
      }
    });
  }

  void deleteTask() {
    emit(DeleteTaskLoadingState());
    DioHelper.delete(
      endPoint: '$tasks/${taskModel?.tasks?[currentTaskIndex].id}',
      token: SharedPreference.get(SharedKeys.userToken),
    ).then((value) {
      print(value.data);
      taskModel?.tasks?.removeAt(currentTaskIndex);
      emit(DeleteTaskSuccessState());
    }).catchError((onError){
      if (onError is DioError) {
        print(onError.response?.data);
        Fluttertoast.showToast(
          msg: "Error in Get All Tasks ${onError.response?.data.toString()}",
          // toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          // timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          // textColor: Colors.white,
          // fontSize: 16.0
        );
        emit(EditTaskErrorState());
      }
    });
  }

  // List<TaskModel> tasks = [
  //   TaskModel(
  //     title: 'Learn Flutter',
  //     description: 'You Must Learn State Managemnt',
  //     startDate: '12-12-1221',
  //     endDate: '12-12-1221',
  //   ),
  //   TaskModel(
  //     title: 'Learn Flutter asd asd as d asd as d as d ads a sd a sd a sd as d as d as d',
  //     description: 'You Must Learn State Managemnt as d as d as d as d as d asd a sd a sd as d as d a sd as d asd ',
  //     startDate: '12-12-1221 12:12',
  //     endDate: '12-12-1221 12:12',
  //   ),
  //   // TaskModel(
  //   //   title: 'Learn Flutter asd asd as d asd as d as d ads a sd a sd a sd as d as d as d',
  //   //   description: 'You Must Learn State Managemnt as d as d as d as d as d asd a sd a sd as d as d a sd as d asd ',
  //   //   startDate: '12-12-1221 12:12',
  //   //   endDate: '12-12-1221 12:12',
  //   // ),
  //   // TaskModel(
  //   //   title: 'Learn Flutter asd asd as d asd as d as d ads a sd a sd a sd as d as d as d',
  //   //   description: 'You Must Learn State Managemnt as d as d as d as d as d asd a sd a sd as d as d a sd as d asd ',
  //   //   startDate: '12-12-1221 12:12',
  //   //   endDate: '12-12-1221 12:12',
  //   // ),
  //   // TaskModel(
  //   //   title: 'Learn Flutter asd asd as d asd as d as d ads a sd a sd a sd as d as d as d',
  //   //   description: 'You Must Learn State Managemnt as d as d as d as d as d asd a sd a sd as d as d a sd as d asd ',
  //   //   startDate: '12-12-1221 12:12',
  //   //   endDate: '12-12-1221 12:12',
  //   // ),
  //   // TaskModel(
  //   //   title: 'Learn Flutter asd asd as d asd as d as d ads a sd a sd a sd as d as d as d',
  //   //   description: 'You Must Learn State Managemnt as d as d as d as d as d asd a sd a sd as d as d a sd as d asd ',
  //   //   startDate: '12-12-1221 12:12',
  //   //   endDate: '12-12-1221 12:12',
  //   // ),
  //   // TaskModel(
  //   //   title: 'Learn Flutter asd asd as d asd as d as d ads a sd a sd a sd as d as d as d',
  //   //   description: 'You Must Learn State Managemnt as d as d as d as d as d asd a sd a sd as d as d a sd as d asd ',
  //   //   startDate: '12-12-1221 12:12',
  //   //   endDate: '12-12-1221 12:12',
  //   // ),
  //   // TaskModel(
  //   //   title: 'Learn Flutter asd asd as d asd as d as d ads a sd a sd a sd as d as d as d',
  //   //   description: 'You Must Learn State Managemnt as d as d as d as d as d asd a sd a sd as d as d a sd as d asd ',
  //   //   startDate: '12-12-1221 12:12',
  //   //   endDate: '12-12-1221 12:12',
  //   // ),
  //   // TaskModel(
  //   //   title: 'Learn Flutter asd asd as d asd as d as d ads a sd a sd a sd as d as d as d',
  //   //   description: 'You Must Learn State Managemnt as d as d as d as d as d asd a sd a sd as d as d a sd as d asd ',
  //   //   startDate: '12-12-1221 12:12',
  //   //   endDate: '12-12-1221 12:12',
  //   // ),
  //   // TaskModel(
  //   //   title: 'Learn Flutter asd asd as d asd as d as d ads a sd a sd a sd as d as d as d',
  //   //   description: 'You Must Learn State Managemnt as d as d as d as d as d asd a sd a sd as d as d a sd as d asd ',
  //   //   startDate: '12-12-1221 12:12',
  //   //   endDate: '12-12-1221 12:12',
  //   // ),
  //   // TaskModel(
  //   //   title: 'Learn Flutter asd asd as d asd as d as d ads a sd a sd a sd as d as d as d',
  //   //   description: 'You Must Learn State Managemnt as d as d as d as d as d asd a sd a sd as d as d a sd as d asd ',
  //   //   startDate: '12-12-1221 12:12',
  //   //   endDate: '12-12-1221 12:12',
  //   // ),
  //   // TaskModel(
  //   //   // title: 'Learn Flutter asd asd as d asd as d as d ads a sd a sd a sd as d as d as d',
  //   //   // description: 'You Must Learn State Managemnt as d as d as d as d as d asd a sd a sd as d as d a sd as d asd ',
  //   //   startDate: '12-12-1221 12:12',
  //   //   endDate: '12-12-1221 12:12',
  //   // ),
  // ];

  var titleController = TextEditingController();
  var descriptionController = TextEditingController();
  var startDateController = TextEditingController();
  var endDateController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  // void addTask() {
  //   emit(AddTaskLoadingState());
  //   try {
  //     tasks.add(
  //       TaskModel(
  //         title: titleController.text,
  //         description: descriptionController.text,
  //         startDate: startDateController.text,
  //         endDate: endDateController.text,
  //       ),
  //     );
  //     emit(AddTaskSuccessState());
  //   } catch (e) {
  //     emit(AddTaskErrorState());
  //   }
  // }

  void clearControllers() {
    titleController.clear();
    descriptionController.clear();
    startDateController.clear();
    endDateController.clear();
  }

  int currentTaskIndex = 0;

  void changeCurrentTask(int index) {
    currentTaskIndex = index;
  }

  void initController() {
    titleController.text = taskModel?.tasks?[currentTaskIndex].title ?? '';
    descriptionController.text = taskModel?.tasks?[currentTaskIndex].description ?? '';
    startDateController.text = taskModel?.tasks?[currentTaskIndex].startDate ?? '';
    endDateController.text = taskModel?.tasks?[currentTaskIndex].endDate ?? '';
  }

  void initControllerFireBase() {
    titleController.text = tasksFireBase[currentTaskIndex].title ?? '';
    descriptionController.text = tasksFireBase[currentTaskIndex].description ?? '';
    startDateController.text = tasksFireBase[currentTaskIndex].startDate ?? '';
    endDateController.text = tasksFireBase[currentTaskIndex].endDate ?? '';
  }

// void editTask(){
//   emit(EditTaskLoadingState());
//   tasks[currentTaskIndex].title = titleController.text;
//   tasks[currentTaskIndex].description = descriptionController.text;
//   tasks[currentTaskIndex].startDate = startDateController.text;
//   tasks[currentTaskIndex].endDate = endDateController.text;
//   emit(EditTaskSuccessState());
// }

// void deleteTask(){
//   emit(DeleteTaskLoadingState());
//   tasks.removeAt(currentTaskIndex);
//   emit(DeleteTaskSuccessState());
// }
}
