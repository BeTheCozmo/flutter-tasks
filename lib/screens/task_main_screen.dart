import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tasks/screens/priorities_screen.dart';
import 'package:tasks/screens/task_list_screen.dart';
import 'package:tasks/services/auth_service.dart';
import '../services/task_service.dart';

class TaskMainScreen extends StatefulWidget {
  final TaskService taskService;
  final AuthService authService;
  
  TaskMainScreen({required this.taskService, required this.authService});

  @override
  _TaskMainScreenState createState() => _TaskMainScreenState();
}

class _TaskMainScreenState extends State<TaskMainScreen> {
  int _selectedIndex = 0;
  String _updatedData = "";

  late final List<Widget> _screens;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _screens = [
      TaskListScreen(taskService: widget.taskService, authService: widget.authService) as StatefulWidget,
      TasksByPriorityScreen(taskService: widget.taskService, authService: widget.authService) as StatefulWidget,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: "Tarefas",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_kanban_outlined),
            label: "Prioridades",
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        onTap: _onItemTapped,
      ),
    );
  }
}