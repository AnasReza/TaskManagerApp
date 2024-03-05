import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/task.dart';
import '../../domain/usecases/ad_task_usecase.dart';
import '../../domain/usecases/delete_task_usecase.dart';
import '../../domain/usecases/get_task_usecase.dart';

abstract class TaskEvent {}

class LoadTasksEvent extends TaskEvent {}

class AddTaskEvent extends TaskEvent {
  final Task task;

  AddTaskEvent(this.task);
}

class DeleteTaskEvent extends TaskEvent {
  final Task task;

  DeleteTaskEvent(this.task);
}

// Define states
abstract class TaskState {}

class LoadingState extends TaskState {}

class LoadedState extends TaskState {
  final List<Task> tasks;

  LoadedState(this.tasks);
}

class ErrorState extends TaskState {
  final String message;

  ErrorState(this.message);
}

// BLoC implementation
class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetTasksUseCase getTasksUseCase;
  final AddTaskUseCase addTaskUseCase;
  final DeleteTaskUseCase deleteTaskUseCase;

  TaskBloc({
    required this.getTasksUseCase,
    required this.addTaskUseCase,
    required this.deleteTaskUseCase,
  }) : super(LoadingState()) {
    on<LoadTasksEvent>(_mapLoadTasksToState);
    on<AddTaskEvent>(_mapAddTaskToState);
    on<DeleteTaskEvent>(_mapDeleteTaskToState);
  }

  void _mapLoadTasksToState(LoadTasksEvent event, Emitter<TaskState> emit) async {
    emit(LoadingState());
    try {
      final tasks = await getTasksUseCase.execute();
      emit(LoadedState(tasks));
    } catch (e) {
      emit(ErrorState("Error loading tasks"));
    }
  }

  void _mapAddTaskToState(AddTaskEvent event, Emitter<TaskState> emit) async {
    try {
      await addTaskUseCase.execute(event.task);
      final tasks = await getTasksUseCase.execute();
      emit(LoadedState(tasks));
    } catch (e) {
      emit(ErrorState("Error adding task"));
    }
  }

  void _mapDeleteTaskToState(DeleteTaskEvent event, Emitter<TaskState> emit) async {
    try {
      await deleteTaskUseCase.execute(event.task);
      final tasks = await getTasksUseCase.execute();
      emit(LoadedState(tasks));
    } catch (e) {
      emit(ErrorState("Error deleting task"));
    }
  }
}