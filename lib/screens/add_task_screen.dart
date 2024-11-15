import 'package:flutter/material.dart';
import 'package:tasks/services/task_service.dart';

import '../models/task.dart';
import '../services/log_service.dart';

class AddTaskScreen extends StatefulWidget {
  final TaskService taskService;
  AddTaskScreen({required this.taskService});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  late Task task;

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  String _status = 'todo';
  String _priority = 'low';

  final Map<String, String> _statusMap = {
    'refinement': 'Em refinamento',
    'todo': 'Pronto para começar',
    'in progress': 'Em progresso',
    'done': 'Realizado',
  };

  final Map<String, String> _priorityMap = {
    'low': 'Baixa',
    'mid': 'Média',
    'high': 'Alta',
  };

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  void _createTask() async {
    task = Task(
      title: _titleController.text,
      description: _descriptionController.text,
      status: _status,
      priority: _priority,
    );
    await widget.taskService.create(task);
    LogService.log('Tarefa criada com sucesso');
    Navigator.pop(context, "Tarefa criada.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Tarefa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Descrição'),
              maxLines: 4,
            ),
            const SizedBox(height: 10),
            // Dropdown para status
            DropdownButton(
              value: _status,
              items: _statusMap.keys.toList().map((value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(_statusMap[value]!),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  if (value is String) {
                    _status = value;
                  }
                });
                LogService.log("Status atualizado para $_status");
              },
              hint: const Text('Selecione o Status'),
              isExpanded: true,
            ),
            const SizedBox(height: 10),
            DropdownButton(
              value: _priority,
              items: _priorityMap.keys.toList().map((value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(_priorityMap[value]!),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  if (value is String) {
                    _priority = value;
                  }
                });
                LogService.log("Prioridade atualizada para $_priority");
              },
              hint: const Text('Selecione a Prioridade'),
              isExpanded: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createTask,
              child: const Text('Criar'),
            ),
          ],
        ),
      ),
    );
  }
}
