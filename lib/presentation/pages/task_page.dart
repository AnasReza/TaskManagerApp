
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/domain/repositories/ConcreteTaskRepository.dart';
import 'package:task_app/domain/repositories/task_repository.dart';

import '../../domain/entities/task.dart';
import '../../domain/usecases/ad_task_usecase.dart';
import '../../domain/usecases/delete_task_usecase.dart';
import '../../domain/usecases/get_task_usecase.dart';
import '../bloc/task_bloc.dart';

class TaskPage extends StatefulWidget {
  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  late TaskBloc _taskBloc;
  ConcreteTaskRepository taskRepo=ConcreteTaskRepository();

  @override
  void initState() {
    super.initState();
    _taskBloc = TaskBloc(
      getTasksUseCase: GetTasksUseCase(taskRepo),
      addTaskUseCase: AddTaskUseCase(taskRepo),
      deleteTaskUseCase: DeleteTaskUseCase(taskRepo),
    )..add(LoadTasksEvent());
  }

  @override
  void dispose() {
    _taskBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _taskBloc = TaskBloc(
      getTasksUseCase: GetTasksUseCase(taskRepo),
      addTaskUseCase: AddTaskUseCase(taskRepo),
      deleteTaskUseCase: DeleteTaskUseCase(taskRepo),
    )..add(LoadTasksEvent());
    return BlocProvider(
      create: (context) => _taskBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Task Manager"),
        ),
        body: BlocBuilder<TaskBloc, TaskState>(
          builder: (context, state) {
            print('inside blocbuilder');
            if (state is LoadingState) {
              print('CircularProgressIndicator()');
              return Center(child: CircularProgressIndicator());
            } else if (state is LoadedState) {
              print('_buildTaskList(state.tasks)');
              return _buildTaskList(state.tasks);
            } else if (state is ErrorState) {
              print('ErrorState');
              return Center(child: Text(state.message,style: TextStyle(color: Colors.black),));
            }
            return Container(width: 100,height: 100,color: Colors.red,);
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showAddTaskDialog(context);
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildTaskList(List<Task> tasks) {
    print('${tasks.length} tasks length');
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        print('${task.title} task title');
        return ListTile(
          title: Text(task.title,style: const TextStyle(color: Colors.black),),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              taskRepo.deleteTask(task).then((value){
                setState(() {

                });
              });
              // _taskBloc.add(DeleteTaskEvent(task));
            },
          ),
        );
      },
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final titleController=TextEditingController();
        return AlertDialog(
          title: Text("Add Task"),
          content: TextField(
            controller: titleController,
            decoration: InputDecoration(labelText: "Task Title"),
            onChanged: (value) {
              // Handle text field changes
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                String title = titleController.text;
                print('$title from add');
                // Get the task title from the text field
                if (title.isNotEmpty) {
                  // _taskBloc.add(AddTaskEvent(Task(title)));
                  taskRepo.addTask(Task(title)).then((value){
                    // _taskBloc.getTasksUseCase.repository.getTasks().then((value){
                    //   for(var v in value){
                    //     print('${v.title} title from add button');
                    //   }
                    // });
                    setState(() {

                    });
                    Navigator.of(context).pop();
                  });
                }else{
                  print('title is empty');
                }


              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }
}