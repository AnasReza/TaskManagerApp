import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:task_app/domain/entities/task.dart';
import 'package:task_app/presentation/bloc/task_bloc.dart';
import 'package:task_app/presentation/pages/task_page.dart';

class MockTaskBloc extends Mock implements TaskBloc {}

void main() {
  late MockTaskBloc mockTaskBloc;

  setUp(() {
    mockTaskBloc = MockTaskBloc();
  });

  testWidgets('TaskPage displays LoadingState', (WidgetTester tester) async {
    when(mockTaskBloc.state).thenReturn(LoadingState());

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: mockTaskBloc,
          child: TaskPage(),
        ),
      ),
    );

    expect(find.text('Loading...'), findsOneWidget);
  });

  testWidgets('TaskPage displays tasks when in LoadedState', (WidgetTester tester) async {
    when(mockTaskBloc.state).thenReturn(LoadedState([Task('Task 1'), Task('Task 2')]));

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: mockTaskBloc,
          child: TaskPage(),
        ),
      ),
    );

    expect(find.text('Task 1'), findsOneWidget);
    expect(find.text('Task 2'), findsOneWidget);
  });

  // Add more widget tests for other UI scenarios as needed.
}