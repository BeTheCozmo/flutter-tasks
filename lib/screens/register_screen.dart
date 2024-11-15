import 'package:flutter/material.dart';
import 'package:tasks/screens/task_main_screen.dart';
import 'package:tasks/services/log_service.dart';
import '../services/auth_service.dart';
import '../services/task_service.dart';

class RegisterScreen extends StatefulWidget {
  final AuthService authService;

  RegisterScreen({required this.authService});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _password2Controller = TextEditingController();

  Future<void> _register() async {
    if(_passwordController.text != _password2Controller.text) {
      LogService.log("As senhas não coincidem, por favor tente novamente.");
      return;
    }

    bool success = await widget.authService.register(
      _usernameController.text,
      _passwordController.text,
      _password2Controller.text,
    );

    if (success) {
      final taskService = TaskService(widget.authService);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => TaskMainScreen(taskService: taskService, authService: widget.authService)),
      );
    } else {
      LogService.log("Erro ao registrar-se, por favor, tente novamente.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Senha'),
                obscureText: true,
              ),
              TextField(
                controller: _password2Controller,
                decoration: const InputDecoration(labelText: 'Confirme sua senha'),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _register, child: const Text('Registrar')),
            ],
          ),
        ),
      ),
    );
  }
}