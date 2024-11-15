import 'package:flutter/material.dart';
import 'package:tasks/services/log_service.dart';
import '../services/auth_service.dart';
import '../services/task_service.dart';
import 'task_main_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  final AuthService authService;

  LoginScreen({required this.authService});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _login() async {
    bool success = await widget.authService.login(
      _usernameController.text,
      _passwordController.text,
    );

    if (success) {
      final taskService = TaskService(widget.authService);

      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => TaskMainScreen(taskService: taskService, authService: widget.authService)),
      );
    } else {
      LogService.log("Usuário não existe ou senha está incorreta.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
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
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _login, child: const Text('Login')),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => RegisterScreen(authService: widget.authService)),
                  );
                },
                child: const Text(
                  'Registre-se',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}