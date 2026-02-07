import 'package:flutter/material.dart';
import '../controllers/task_controller.dart';
import '../models/task_model.dart';

class UpdateTaskScreen extends StatefulWidget {
  final TaskModel task;
  const UpdateTaskScreen({super.key, required this.task});

  @override
  State<UpdateTaskScreen> createState() => _UpdateTaskScreenState();
}

class _UpdateTaskScreenState extends State<UpdateTaskScreen> {
  late TextEditingController title;
  late TextEditingController desc;
  late String status;

  @override
  void initState() {
    super.initState();
    title = TextEditingController(text: widget.task.title);
    desc = TextEditingController(text: widget.task.description);
    status = widget.task.status;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Update Task")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: title,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: desc,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              value: status,
              items: const [
                DropdownMenuItem(value: "New", child: Text("New")),
                DropdownMenuItem(value: "Progress", child: Text("Progress")),
                DropdownMenuItem(value: "Completed", child: Text("Completed")),
                DropdownMenuItem(value: "Canceled", child: Text("Canceled")),
              ],
              onChanged: (v) => setState(() => status = v!),
              decoration: const InputDecoration(labelText: "Status"),
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () async {
                await TaskController.updateTask(
                  widget.task.id,
                  title.text,
                  desc.text,
                  status,
                );
                Navigator.pop(context, true);
              },
              child: const Text("Update Task"),
            ),
          ],
        ),
      ),
    );
  }
}
