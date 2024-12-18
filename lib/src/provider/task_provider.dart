import 'package:flutter/widgets.dart';
import 'package:task_dio_v2/src/model/task_model.dart';
import 'package:task_dio_v2/src/repository/task_repository.dart';

class TaskProvider extends ChangeNotifier {

  final taskRepository = TaskRepository();

  List<TaskModel> listTasks = [];

  void create(TaskModel taskModel) {
    listTasks.add(taskModel);
    notifyListeners();
    taskRepository.create(taskModel);
  }

  void getAllTasks() async {
    listTasks = await taskRepository.index();
    notifyListeners();
  }

  Future<void> toggleCheck(TaskModel taskModel) async {
    listTasks = await listTasks.map((task) {
      if (taskModel.objectId == task.objectId) {
        task.tarefaIsOk = !task.tarefaIsOk; 
      }

      return task;
    }).toList();
  
    notifyListeners();

    taskRepository.update(taskModel);
  }
}
