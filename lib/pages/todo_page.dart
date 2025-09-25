import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/providers/task_provider.dart';
import 'package:to_do_list/widgets/add_task_bottom_sheet.dart';
import 'package:to_do_list/widgets/task_header.dart';
import 'package:to_do_list/widgets/task_list.dart';

class TodoPage extends StatelessWidget {
  TodoPage({super.key});
  final TextEditingController _controller = TextEditingController();

  void _showAddTaskModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => AddTaskBottomSheet(controller: _controller),
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          title: const Text("To Do"),
          centerTitle: true,
          backgroundColor: Colors.cyan.shade200,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TaskHeader(),
            Expanded(
              child: TaskList(
                filter: taskProvider.filter,
                tasks: taskProvider.tasks,
                activeTasks: taskProvider.tasks
                    .where((t) => !t.isDone)
                    .toList(),
                completedTasks: taskProvider.tasks
                    .where((t) => t.isDone)
                    .toList(),
              ),
            ),
          ],
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(right: 15, bottom: 40),
          child: FloatingActionButton(
            onPressed: () => _showAddTaskModalBottomSheet(context),
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}
