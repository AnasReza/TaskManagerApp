import '../entities/task.dart';
import '../repositories/task_repository.dart';

class DeleteTaskUseCase {
  final TaskRepository repository;

  DeleteTaskUseCase(this.repository);

  Future<void> execute(Task task) {
    return repository.deleteTask(task);
  }
}