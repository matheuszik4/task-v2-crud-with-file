
import '../model/task_model.dart';
import '../services/back4app.dart';

class TaskRepository {

  final back4app = Back4App();

  TaskRepository();

  Future<List<TaskModel>> index() async {
    var result = await back4app.dio.get('/Tarefa');
    print(result.data);
    return TaskModel.fromJsonCollection(result.data);
  }

  Future<void> create(TaskModel taskModel) async {
    try {
      await back4app.dio.post("/Tarefa", data: taskModel.toJsonEndpoint());
    } catch (e) {
      throw e;
    }
  }

  Future<void> delete(String objectId) async {
    try {
      await back4app.dio.delete("/Tarefa/$objectId");
    } catch (e) {
      throw e;
    }
  }

  Future<void> toggleCheck(TaskModel taskModel) async {
    
    var taskModelToggle = taskModel.toJsonEndpoint();
    taskModelToggle['tarefaIsOk'] = !taskModelToggle['tarefaIsOk'];

    try {
      await back4app.dio.put("/Tarefa/${taskModel.objectId}", data: taskModelToggle);
    } catch (e) {
      throw e;
    }

  }

  // Future<TaskModel> show(String cepShow) async {
  //   List<TaskModel> allTasks = await index();
  //   return allTasks.firstWhere((task) => cep.cep == cepShow);
  // }

}