import 'package:flutter/material.dart';
import 'package:to_do_list/providers/task_provider.dart';
import 'package:to_do_list/widgets/task_item.dart';

class TaskList extends StatelessWidget {
  final FilterOption filter;
  final List tasks;
  final List activeTasks;
  final List completedTasks;

  const TaskList({
    super.key,
    required this.filter,
    required this.tasks,
    required this.activeTasks,
    required this.completedTasks,
  });

  @override
  Widget build(BuildContext context) {
    if (filter == FilterOption.all) {
      return ListView(
        children: [
          ...activeTasks.map((t) => TaskItem(task: t)),
          if (completedTasks.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                "Completed",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            ...completedTasks.map((t) => TaskItem(task: t)),
          ],
        ],
      );
    } else if (filter == FilterOption.active) {
      return ListView(
        children: activeTasks.map((t) => TaskItem(task: t)).toList(),
      );
    } else {
      return ListView(
        children: completedTasks.map((t) => TaskItem(task: t)).toList(),
      );
    }
  }
}
