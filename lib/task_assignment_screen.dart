import 'package:flutter/material.dart';
import 'task_list.dart';
import 'task_model.dart';
import 'task_form_screen.dart';

class TaskAssignmentScreen extends StatefulWidget {
  @override
  _TaskAssignmentScreenState createState() => _TaskAssignmentScreenState();
}

class _TaskAssignmentScreenState extends State<TaskAssignmentScreen> {
  List<Task> tasks = [
    // Task(
    //   title: 'Design Homepage',
    //   description: 'Create a design for the homepage',
    //   assignee: 'Alice',
    //   priority: Priority.high,
    //   deadline: DateTime.now().add(Duration(days: 3)),
    //   completed: false,
    // ),
    // Task(
    //   title: 'Fix Login Bug',
    //   description: 'Resolve the login issue for users',
    //   assignee: 'Bob',
    //   priority: Priority.medium,
    //   deadline: DateTime.now().add(Duration(days: 5)),
    //   completed: false,
    // ),
  ];

  List<Task> filteredTasks = [];

  @override
  void initState() {
    super.initState();
    filteredTasks = tasks;
  }

  void addTask(Task task) {
    setState(() {
      tasks.add(task);
      filteredTasks = tasks;
    });
  }

  void editTask(int index, Task updatedTask) {
    setState(() {
      tasks[index] = updatedTask;
      filteredTasks = tasks;
    });
  }

  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
      filteredTasks = tasks;
    });
  }

  void toggleCompleteTask(int index) {
    setState(() {
      tasks[index].completed = !tasks[index].completed;
      filteredTasks = tasks;
    });
  }

  void filterTasks(String filter) {
    setState(() {
      if (filter == 'All') {
        filteredTasks = tasks;
      } else {
        filteredTasks = tasks.where((task) => task.priority.toString().split('.').last == filter).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Assignment'),
        actions: [
          PopupMenuButton<String>(
            onSelected: filterTasks,
            itemBuilder: (BuildContext context) {
              return ['All', 'High', 'Medium', 'Low'].map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: TaskList(
        tasks: filteredTasks,
        onEdit: editTask,
        onDelete: deleteTask,
        onToggleComplete: toggleCompleteTask,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Task? newTask = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TaskFormScreen()),
          );
          if (newTask != null) {
            addTask(newTask);
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
