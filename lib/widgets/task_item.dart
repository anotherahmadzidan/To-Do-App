import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  const TaskItem({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: task.isDone ? Colors.green.shade50 : Colors.white,
      child: ListTile(
        leading: Checkbox(
          value: task.isDone,
          onChanged: (_) {
            Provider.of<TaskProvider>(context, listen: false).toggleTask(task);
          },
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            final taskProvider = Provider.of<TaskProvider>(
              context,
              listen: false,
            );
            taskProvider.deleteTask(task);

            // Snackbar Undo
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Task "${task.title}" is removed.'),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () {
                    taskProvider.addTask(task.title); // tambahkan kembali
                  },
                ),
                duration: const Duration(seconds: 3),
              ),
            );
          },
        ),
      ),
    );
  }
}
