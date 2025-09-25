import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/providers/task_provider.dart';

class AddTaskBottomSheet extends StatefulWidget {
  final TextEditingController controller;

  const AddTaskBottomSheet({super.key, required this.controller});

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  String? errorText;

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

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
            controller: widget.controller,
            decoration: InputDecoration(
              hintText: 'Add Task Here',
              border: const OutlineInputBorder(),
              errorText: errorText,
            ),
            autofocus: true,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  if (widget.controller.text.trim().length >= 3) {
                    taskProvider.addTask(widget.controller.text.trim());
                    widget.controller.clear();
                    Navigator.pop(context);
                  } else {
                    setState(() {
                      errorText = "Minimal 3 karakter";
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
  }
}
