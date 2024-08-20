import 'package:flutter/material.dart';
import 'task_assignment_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,
      title: 'Task Assignment',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TaskAssignmentScreen(),
    );
  }
}
