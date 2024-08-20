import 'package:flutter/material.dart';
import 'task_model.dart';
import 'package:intl/intl.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? task;

  TaskFormScreen({this.task});

  @override
  _TaskFormScreenState createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late String _assignee;
  late Priority _priority;
  late DateTime _deadline;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _title = widget.task!.title;
      _description = widget.task!.description;
      _assignee = widget.task!.assignee;
      _priority = widget.task!.priority;
      _deadline = widget.task!.deadline;
    } else {
      _title = '';
      _description = '';
      _assignee = '';
      _priority = Priority.medium;
      _deadline = DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Add Task' : 'Edit Task'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(
                label: 'Title',
                initialValue: _title,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
              ),
              _buildTextField(
                label: 'Description',
                initialValue: _description,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                onSaved: (value) {
                  _description = value!;
                },
              ),
              _buildTextField(
                label: 'Assignee',
                initialValue: _assignee,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an assignee';
                  }
                  return null;
                },
                onSaved: (value) {
                  _assignee = value!;
                },
              ),
              DropdownButtonFormField<Priority>(
                value: _priority,
                decoration: InputDecoration(
                  labelText: 'Priority',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                items: Priority.values.map((Priority priority) {
                  return DropdownMenuItem<Priority>(
                    value: priority,
                    child: Text(priority.toString().split('.').last),
                  );
                }).toList(),
                onChanged: (Priority? newValue) {
                  setState(() {
                    _priority = newValue!;
                  });
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  "Deadline: ${DateFormat('yyyy-MM-dd – kk:mm').format(_deadline)}",
                ),
                trailing: Icon(Icons.calendar_today),
                onTap: _pickDeadline,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    Navigator.pop(
                      context,
                      Task(
                        title: _title,
                        description: _description,
                        assignee: _assignee,
                        priority: _priority,
                        deadline: _deadline,
                        completed: widget.task?.completed ?? false,
                      ),
                    );
                  }
                },
                child: Text(widget.task == null ? 'Add Task' : 'Save Changes'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String initialValue,
    required FormFieldValidator<String> validator,
    required FormFieldSetter<String> onSaved,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }

  void _pickDeadline() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _deadline,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: _deadline.hour, minute: _deadline.minute),
      );
      if (pickedTime != null) {
        setState(() {
          _deadline = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }
}
