
import '../model/task_model.dart';
import '../services/back4app.dart';

class TaskRepository {

  final back4app = Back4App();

  TaskRepository();

  Future<List<TaskModel>> index() async {
    var result = await back4app.dio.get('/Tarefa');
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

  Future<void> update(TaskModel taskModel) async {
    var taskModelToggle = taskModel.toJsonEndpoint();
    print(taskModelToggle);

    try {
      await back4app.dio.put("/Tarefa/${taskModel.objectId}", data: taskModelToggle);
    } catch (e) {
      throw e;
    }

  }
}