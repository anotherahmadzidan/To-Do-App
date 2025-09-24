import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/providers/task_provider.dart';
import 'package:to_do_list/widgets/task_item.dart';

class TodoPage extends StatelessWidget {
  TodoPage({super.key});
  final TextEditingController _controller = TextEditingController();

  void _showAddTaskModalBottomSheet(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        String? errorText; // untuk menampung pesan error

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Add Task",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Add Task Here',
                      border: const OutlineInputBorder(),
                      errorText: errorText, // tampilkan pesan error
                    ),
                    autofocus: true,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          if (_controller.text.trim().length >= 3) {
                            taskProvider.addTask(_controller.text.trim());
                            _controller.clear();
                            Navigator.pop(context); // tutup modal
                          } else {
                            setModalState(() {
                              errorText = "Minimal 3 karakter"; // set error
                            });
                          }
                        },
                        label: const Text('Save'),
                        icon: const Icon(Icons.send_rounded),
                        iconAlignment: IconAlignment.end,
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    // Pisahkan task
    final activeTasks = taskProvider.tasks.where((t) => !t.isDone).toList();
    final completedTasks = taskProvider.tasks.where((t) => t.isDone).toList();

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
            // ===== Header Task + Filter =====
            // ===== Header Section (dinamis) =====
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    taskProvider.filter == FilterOption.done
                        ? "Completed"
                        : "Task",
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
                        side: BorderSide(color: Colors.black),
                      ),
                      icon: const Icon(
                        Icons.arrow_drop_down_rounded,
                        size: 20,
                        color: Colors.black,
                      ),
                      label: Text(
                        style: TextStyle(color: Colors.black),
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

            // ===== Jumlah tugas aktif =====
            Padding(
              padding: const EdgeInsets.only(bottom: 5, left: 16, right: 16),
              child: Text(
                "Active task: ${taskProvider.activeTaskCount}",
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),

            // ===== List Task Section =====
            Expanded(
              child: Builder(
                builder: (context) {
                  if (taskProvider.filter == FilterOption.all) {
                    return ListView(
                      children: [
                        ...activeTasks.map((t) => TaskItem(task: t)),

                        if (completedTasks.isNotEmpty) ...[
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: Text(
                              "Completed",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ...completedTasks.map((t) => TaskItem(task: t)),
                        ],
                      ],
                    );
                  } else if (taskProvider.filter == FilterOption.active) {
                    return ListView(
                      children: activeTasks
                          .map((t) => TaskItem(task: t))
                          .toList(),
                    );
                  } else {
                    return ListView(
                      children: completedTasks
                          .map((t) => TaskItem(task: t))
                          .toList(),
                    );
                  }
                },
              ),
            ),
          ],
        ),

        // ===== FAB Add =====
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
