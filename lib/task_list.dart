import 'package:flutter/material.dart';
import 'task_model.dart';
import 'task_card.dart';
import 'task_form_screen.dart';

class TaskList extends StatelessWidget {
  final List<Task> tasks;
  final Function(int, Task) onEdit;
  final Function(int) onDelete;
  final Function(int) onToggleComplete;

  TaskList({
    required this.tasks,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleComplete,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () async {
            Task? editedTask = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TaskFormScreen(task: tasks[index]),
              ),
            );
            if (editedTask != null) {
              onEdit(index, editedTask);
            }
          },
          child: TaskCard(
            task: tasks[index],
            onDelete: () => onDelete(index),
            onToggleComplete: () => onToggleComplete(index),
          ),
        );
      },
    );
  }
}
