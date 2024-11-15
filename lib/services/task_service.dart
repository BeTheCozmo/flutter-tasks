import 'dart:convert';
import '../models/task.dart';
import 'auth_service.dart';
import 'package:http/http.dart' as http;

import 'log_service.dart';

class TaskService {
  final AuthService authService;
  TaskService(this.authService);

  final String _baseUrl = 'http://192.168.0.20:3000';

  Future<List<Task>> fetchTasks() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/tasks'),
      headers: {'Authorization': 'Bearer ${authService.token}'},
    );

    if(response.statusCode >= 200 && response.statusCode < 300) {
      List<dynamic> tasksJson = json.decode(response.body);
      return tasksJson.map((json) => Task.fromJson(json)).toList();
    } else {
      LogService.log("Falha ao carregar tarefas.");
      throw Exception('Falha ao carregar tarefas.');
    }
  }

  Future<bool> create(Task task) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/tasks'),
      headers: {
        'Authorization': 'Bearer ${authService.token}',
        'Content-Type': 'application/json',
      },
      body: json.encode(task.toJson())
    );

    if(!(response.statusCode >= 200 && response.statusCode < 300)) {
      LogService.log("Erro ao criar tarefa.");
      return false;
    }
    return true;
  }

  Future<bool> update(Task task) async {
    final response = await http.patch(
      Uri.parse('$_baseUrl/tasks/${task.id}'),
      headers: {
        'Authorization': 'Bearer ${authService.token}',
        'Content-Type': 'application/json',
      },
      body: json.encode(task.toJson()),
    );

    if(!(response.statusCode >= 200 && response.statusCode < 300)) {
      LogService.log("Erro ao atualizar tarefa.");
      return false;
    }
    return true;
  }

  Future<bool> delete(Task task) async {
    final response = await http.delete(
        Uri.parse('$_baseUrl/tasks/${task.id}'),
        headers: {
          'Authorization': 'Bearer ${authService.token}',
          'Content-Type': 'application/json',
        },
        body: json.encode(task.toJson())
    );

    if(!(response.statusCode >= 200 && response.statusCode < 300)) {
      LogService.log("Erro ao criar tarefa.");
      return false;
    }
    return true;
  }
}