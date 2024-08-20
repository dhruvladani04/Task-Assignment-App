import 'package:flutter/material.dart';
import 'task_form_screen.dart';
import 'task_model.dart';
import 'task_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> tasks = [];
  Priority? selectedFilter;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> taskStrings = tasks.map((task) => jsonEncode(task.toJson())).toList();
    await prefs.setStringList('tasks', taskStrings);
  }

  Future<void> _loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? taskStrings = prefs.getStringList('tasks');
    if (taskStrings != null) {
      setState(() {
        tasks = taskStrings.map((taskString) => Task.fromJson(jsonDecode(taskString))).toList();
      });
    }
  }

  void _addTask(Task task) {
    setState(() {
      tasks.add(task);
      _saveTasks();
    });
  }

  void _deleteTask(Task task) {
    setState(() {
      tasks.remove(task);
      _saveTasks();
    });
  }

  void _toggleComplete(Task task) {
    setState(() {
      task.completed = !task.completed;
      _saveTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Task> filteredTasks = selectedFilter == null
        ? tasks
        : tasks.where((task) => task.priority == selectedFilter).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Task List'),
        actions: [
          PopupMenuButton<Priority?>(
            onSelected: (Priority? result) {
              setState(() {
                selectedFilter = result;
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<Priority?>>[
              const PopupMenuItem<Priority?>(
                value: null,
                child: Text('All'),
              ),
              const PopupMenuItem<Priority?>(
                value: Priority.high,
                child: Text('High Priority'),
              ),
              const PopupMenuItem<Priority?>(
                value: Priority.medium,
                child: Text('Medium Priority'),
              ),
              const PopupMenuItem<Priority?>(
                value: Priority.low,
                child: Text('Low Priority'),
              ),
            ],
            icon: Icon(Icons.filter_list),
          ),
        ],
      ),
      body: filteredTasks.isEmpty
          ? Center(child: Text('No tasks available.'))
          : ListView.builder(
        itemCount: filteredTasks.length,
        itemBuilder: (context, index) {
          return TaskCard(
            task: filteredTasks[index],
            onDelete: () => _deleteTask(filteredTasks[index]),
            onToggleComplete: () => _toggleComplete(filteredTasks[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          Task? newTask = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TaskFormScreen()),
          );
          if (newTask != null) {
            _addTask(newTask);
          }
        },
      ),
    );
  }
}
