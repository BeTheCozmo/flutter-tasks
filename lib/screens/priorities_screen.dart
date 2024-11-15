import 'package:flutter/material.dart';
import 'package:tasks/constants/actions.dart';
import 'package:tasks/screens/task_screen.dart';
import 'package:tasks/utils/task.dart';
import '../models/task.dart';
import '../services/auth_service.dart';
import '../services/log_service.dart';
import '../services/task_service.dart';
import 'add_task_screen.dart';

class TasksByPriorityScreen extends StatefulWidget {
  final TaskService taskService;
  final AuthService authService;
  TasksByPriorityScreen({required this.taskService, required this.authService});

  @override
  State<TasksByPriorityScreen> createState() => _TasksByPriorityScreenState();
}

class _TasksByPriorityScreenState extends State<TasksByPriorityScreen> {
  String _updatedData = '';
  final Map<String, String> _priorityMap = {
    'low': 'Baixa',
    'mid': 'Média',
    'high': 'Alta',
  };

  late List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    final fetchedTasks = await widget.taskService.fetchTasks();
    setState(() {
      tasks = fetchedTasks;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, List<Task>> tasksByPriority = {
      'Baixa': tasks.where((task) => task.priority == 'low').toList(),
      'Média': tasks.where((task) => task.priority == 'mid').toList(),
      'Alta': tasks.where((task) => task.priority == 'high').toList(),
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        actions: actions(context, widget, setState, _updatedData),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: tasksByPriority.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Prioridade: ${entry.key}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Column(
                        children: entry.value.map((task) {
                          return ListTile(
                            leading: Icon(task.status == 'done' ? Icons.check_box : Icons.check_box_outline_blank),
                            title: Text(task.title),
                            subtitle: Text(task.description),
                            trailing: Text(
                              parseStatus(task.status),
                              style: TextStyle(
                                color: task.status == 'done'
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                            onTap: () async {
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
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}