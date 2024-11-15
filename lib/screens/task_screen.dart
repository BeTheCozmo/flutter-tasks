import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tasks/services/log_service.dart';

import '../models/task.dart';
import '../services/task_service.dart';

class TaskScreen extends StatefulWidget {
  final TaskService taskService;
  Task task;
  TaskScreen({required this.taskService, required this.task});

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late String _status;
  late String _priority;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(text: widget.task.description);
    _status = widget.task.status;
    _priority = widget.task.priority;
  }

  void _saveTask() {
    widget.task.title = _titleController.text;
    widget.task.description = _descriptionController.text;
    widget.task.status = _status;
    widget.task.priority = _priority;

    widget.taskService.update(widget.task);
    LogService.log('Tarefa atualizada com sucesso');
    Navigator.pop(context, "Tarefa atualizada");
  }

  void _deleteTask() {
    widget.taskService.delete(widget.task);
    LogService.log('Tarefa excluída');
    Navigator.pop(context, "Tarefa excluída");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da Tarefa'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteTask,
          ),
        ],
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

            DropdownButton<String>(
              value: _status ?? 'todo',
              onChanged: (String? newValue) {
                setState(() {
                  _status = newValue ?? "";
                });
              },
              items: const [
                DropdownMenuItem(value: 'refinement', child: Text('Em refinamento')),
                DropdownMenuItem(value: 'todo', child: Text('Pronto para começar')),
                DropdownMenuItem(value: 'in progress', child: Text('Em progresso')),
                DropdownMenuItem(value: 'done', child: Text('Realizado')),
              ],
              hint: const Text('Selecione o Status'),
            ),
            const SizedBox(height: 10),

            DropdownButton<String?>(
              value: _priority ?? 'low',
              onChanged: (String? newValue) {
                setState(() {
                  _priority = newValue ?? "";
                });
              },
              items: const [
                DropdownMenuItem(value: 'low', child: Text('Baixa')),
                DropdownMenuItem(value: 'mid', child: Text('Média')),
                DropdownMenuItem(value: 'high', child: Text('Alta')),
              ],
              hint: const Text('Selecione a Prioridade'),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _saveTask,
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}