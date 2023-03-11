import 'package:todo_shared/view/screens/Task_screen/tasks_screen.dart';

abstract class TaskState{}

class TaskInitState extends TaskState{}

class AddTaskLoadingState extends TaskState{}
class AddTaskSuccessState extends TaskState{}
class AddTaskErrorState extends TaskState{}

class EditTaskLoadingState extends TaskState{}
class EditTaskSuccessState extends TaskState{}
class EditTaskErrorState extends TaskState{}

class DeleteTaskLoadingState extends TaskState{}
class DeleteTaskSuccessState extends TaskState{}
class DeleteTaskErrorState extends TaskState{}

class GetAllTasksLoadingState extends TaskState{}
class GetAllTasksSuccessState extends TaskState{}
class GetAllTasksErrorState extends TaskState{}