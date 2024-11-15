import 'package:flutter/material.dart';
import 'package:tasks/screens/add_task_screen.dart';
import 'package:tasks/screens/login_screen.dart';

List<Widget> actions(context, widget, setState, _updatedData) {
  return [
    IconButton(
      icon: const Icon(Icons.add),
      onPressed: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddTaskScreen(taskService: widget.taskService)),
        );
        if(result != null) {
          setState(() {
            _updatedData = result;
          });
        }
      },
    ),
    IconButton(
      icon: const Icon(Icons.exit_to_app),
      onPressed: () async {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => LoginScreen(authService: widget.authService)),
        );
      },
    ),
  ];
}