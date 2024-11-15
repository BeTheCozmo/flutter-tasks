import 'package:flutter/material.dart';
import 'package:tasks/services/log_service.dart';

import '../constants/actions.dart';
import '../models/task.dart';
import '../services/auth_service.dart';
import '../services/task_service.dart';
import 'add_task_screen.dart';
import 'task_screen.dart';

class TaskListScreen extends StatefulWidget {
  final TaskService taskService;
  final AuthService authService;
  TaskListScreen({required this.taskService, required this.authService});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  String _updatedData = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        actions: actions(context, widget, setState, _updatedData),
      ),
      body: FutureBuilder<List<Task>>(
        future: widget.taskService.fetchTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Erro: ${snapshot.error}');
          } else {
            final tasks = snapshot.data!;
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];

                Color tileColor = Colors.white;
                String tileStatus = "";
                switch (task.status) {
                  case 'refinement':
                    tileColor = Colors.pinkAccent;
                    tileStatus = "Em refinamento";
                    break;
                  case 'todo':
                    tileColor = Colors.green;
                    tileStatus = "Pronto para começar";
                    break;
                  case 'in progress':
                    tileColor = Colors.orange;
                    tileStatus = "Em progresso";
                    break;
                  case 'done':
                    tileColor = Colors.blue;
                    tileStatus = "Realizado";
                    break;
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: tileColor,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: ListTile(
                      leading:
                      const Icon(Icons.task_alt, color: Colors.black38),
                      trailing: const Icon(Icons.arrow_forward_ios,
                          color: Colors.black87),
                      title: Text(
                        task.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        tileStatus,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      onTap: () async {
                        LogService.log('Acessando tarefa: ${task.title}');
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TaskScreen(
                              task: task, taskService: widget.taskService,
                            ),
                          ),
                        );
                        if(result != null) {
                          setState(() {
                            _updatedData = result;
                          });
                        }
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}