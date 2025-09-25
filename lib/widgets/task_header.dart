import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/providers/task_provider.dart';

class TaskHeader extends StatelessWidget {
  const TaskHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                taskProvider.filter == FilterOption.done ? "Completed" : "Task",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              PopupMenuButton<FilterOption>(
                initialValue: taskProvider.filter,
                onSelected: (value) => taskProvider.setFilter(value),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: FilterOption.all,
                    child: Text("All"),
                  ),
                  const PopupMenuItem(
                    value: FilterOption.active,
                    child: Text("Active"),
                  ),
                  const PopupMenuItem(
                    value: FilterOption.done,
                    child: Text("Completed"),
                  ),
                ],
                child: OutlinedButton.icon(
                  iconAlignment: IconAlignment.end,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.black),
                  ),
                  icon: const Icon(
                    Icons.arrow_drop_down_rounded,
                    size: 20,
                    color: Colors.black,
                  ),
                  label: Text(
                    style: const TextStyle(color: Colors.black),
                    taskProvider.filter == FilterOption.all
                        ? "All"
                        : taskProvider.filter == FilterOption.active
                        ? "Active"
                        : "Completed",
                  ),
                  onPressed: null,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 5, left: 16, right: 16),
          child: Text(
            "Active task: ${taskProvider.activeTaskCount}",
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
