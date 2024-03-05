import 'package:task_app/domain/repositories/task_repository.dart';

import '../entities/task.dart';

class TaskRepositoryImpl implements TaskRepository {
  List<Task> _tasks = [];

  @override
  Future<List<Task>> getTasks() async {
    return _tasks;
  }

  @override
  Future<void> addTask(Task task) async {
    _tasks.add(task);
  }

  @override
  Future<void> deleteTask(Task task) async {
    _tasks.remove(task);
  }
}