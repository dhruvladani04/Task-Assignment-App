import 'package:flutter/material.dart';
import 'task_model.dart';
import 'package:intl/intl.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onDelete;
  final VoidCallback onToggleComplete;

  TaskCard({
    required this.task,
    required this.onDelete,
    required this.onToggleComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: getPriorityColor(task.priority),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  child: Text(task.assignee[0]),
                  backgroundColor: Colors.white,
                ),
                SizedBox(width: 10),
                Text(
                  task.assignee,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                IconButton(
                  icon: Icon(
                    task.completed ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: Colors.white,
                  ),
                  onPressed: onToggleComplete,
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.white),
                  onPressed: onDelete,
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              task.title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                decoration: task.completed ? TextDecoration.lineThrough : TextDecoration.none,
              ),
            ),
            SizedBox(height: 5),
            Text(task.description),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Deadline: ${DateFormat('yyyy-MM-dd – kk:mm').format(task.deadline)}',
                  style: TextStyle(color: Colors.white70),
                ),
                Text(
                  task.priority.toString().split('.').last.toUpperCase(),
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color getPriorityColor(Priority priority) {
    switch (priority) {
      case Priority.high:
        return Colors.redAccent;
      case Priority.medium:
        return Colors.orangeAccent;
      case Priority.low:
        return Colors.greenAccent;
      default:
        return Colors.grey;
    }
  }
}
