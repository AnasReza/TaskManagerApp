import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:task_app/domain/entities/task.dart';
import 'package:task_app/domain/usecases/ad_task_usecase.dart';
import 'package:task_app/domain/usecases/delete_task_usecase.dart';
import 'package:task_app/domain/usecases/get_task_usecase.dart';
import 'package:task_app/presentation/bloc/task_bloc.dart';

class MockGetTasksUseCase extends Mock implements GetTasksUseCase {}

class MockAddTaskUseCase extends Mock implements AddTaskUseCase {}

class MockDeleteTaskUseCase extends Mock implements DeleteTaskUseCase {}

void main() {
  group('TaskBloc', () {
    late TaskBloc taskBloc;
    late MockGetTasksUseCase mockGetTasksUseCase;
    late MockAddTaskUseCase mockAddTaskUseCase;
    late MockDeleteTaskUseCase mockDeleteTaskUseCase;

    setUp(() {
      mockGetTasksUseCase = MockGetTasksUseCase();
      mockAddTaskUseCase = MockAddTaskUseCase();
      mockDeleteTaskUseCase = MockDeleteTaskUseCase();

      taskBloc = TaskBloc(
        getTasksUseCase: mockGetTasksUseCase,
        addTaskUseCase: mockAddTaskUseCase,
        deleteTaskUseCase: mockDeleteTaskUseCase,
      );
    });

    test('Initial state is LoadingState', () {
      expect(taskBloc.state, equals(LoadingState()));
    });

    test('Emits LoadedState when LoadTasksEvent is added', () async {
      final tasks = [Task('Task 1'), Task('Task 2')];

      when(mockGetTasksUseCase.execute()).thenAnswer((_) async => tasks);

      taskBloc.add(LoadTasksEvent());

      await expectLater(
        taskBloc,
        emitsInOrder([LoadingState(), LoadedState(tasks)]),
      );
    });

    test('Emits ErrorState when an exception occurs during loading tasks', () async {
      when(mockGetTasksUseCase.execute()).thenThrow(Exception('Some error'));

      taskBloc.add(LoadTasksEvent());

      await expectLater(
        taskBloc,
        emitsInOrder([LoadingState(), ErrorState('Error loading tasks')]),
      );
    });

    // Similar tests for AddTaskEvent and DeleteTaskEvent can be written.
  });
}