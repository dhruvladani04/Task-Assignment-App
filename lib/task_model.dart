enum Priority { high, medium, low }

class Task {
  String title;
  String description;
  String assignee;
  Priority priority;
  DateTime deadline;
  bool completed;

  Task({
    required this.title,
    required this.description,
    required this.assignee,
    required this.priority,
    required this.deadline,
    this.completed = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'assignee': assignee,
      'priority': priority.toString().split('.').last,
      'deadline': deadline.toIso8601String(),
      'completed': completed,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'],
      description: json['description'],
      assignee: json['assignee'],
      priority: Priority.values.firstWhere((e) => e.toString().split('.').last == json['priority']),
      deadline: DateTime.parse(json['deadline']),
      completed: json['completed'],
    );
  }
}
