import 'package:flutter/material.dart';
import '../controllers/task_controller.dart';
import '../models/task_model.dart';
import 'add_task_screen.dart';
import 'update_task_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  String status = "New";
  List<TaskModel> tasks = [];
  Map<String, int> count = {};
  bool loading = false;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    loading = true;
    setState(() {});
    tasks = await TaskController.fetchTasks(status);
    count = await TaskController.statusCount();
    loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      body: SafeArea(
        child: Column(
          children: [
            header(),
            summary(),
            Expanded(
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: tasks.length,
                      itemBuilder: (_, i) => taskCard(tasks[i]),
                    ),
            ),
          ],
        ),
      ),


      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF27AE60),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTaskScreen()),
          );
          load();
        },
        child: const Icon(Icons.add),
      ),

      bottomNavigationBar: nav(),
    );
  }

  Widget header() => Container(
    padding: const EdgeInsets.all(16),
    color: const Color(0xFF27AE60),
    child: const Row(
      children: [
        CircleAvatar(radius: 22),
        SizedBox(width: 12),
        Text(
          "Task Dashboard",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ],
    ),
  );

  Widget summary() => Container(
    padding: const EdgeInsets.all(12),
    color: const Color(0xFF27AE60),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        box("Canceled"),
        box("Completed"),
        box("Progress"),
        box("New"),
      ],
    ),
  );

  Widget box(String s) => Container(
    width: 75,
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      children: [
        Text(
          "${count[s] ?? 0}",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(s, style: const TextStyle(fontSize: 10)),
      ],
    ),
  );


  Widget taskCard(TaskModel t) => Card(
    child: ListTile(
      title: Text(t.title),
      subtitle: Text(t.description),
      onTap: () async {
        final updated = await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => UpdateTaskScreen(task: t)),
        );
        if (updated == true) load();
      },
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButton<String>(
            value: t.status,
            underline: const SizedBox(),
            items: const [
              DropdownMenuItem(value: "New", child: Text("New")),
              DropdownMenuItem(value: "Progress", child: Text("Progress")),
              DropdownMenuItem(value: "Completed", child: Text("Completed")),
              DropdownMenuItem(value: "Canceled", child: Text("Canceled")),
            ],
            onChanged: (v) async {
              await TaskController.updateStatus(t.id, v!);
              load();
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.green),
            onPressed: () async {
              final updated = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => UpdateTaskScreen(task: t)),
              );
              if (updated == true) load();
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () async {
              await TaskController.deleteTask(t.id);
              load();
            },
          ),
        ],
      ),
    ),
  );


  BottomNavigationBar nav() => BottomNavigationBar(
    currentIndex: ["New", "Completed", "Canceled", "Progress"].indexOf(status),
    onTap: (i) {
      status = ["New", "Completed", "Canceled", "Progress"][i];
      load();
    },
    selectedItemColor: const Color(0xFF27AE60),
    unselectedItemColor: Colors.grey,
    items: const [
      BottomNavigationBarItem(icon: Icon(Icons.add), label: "New"),
      BottomNavigationBarItem(icon: Icon(Icons.done), label: "Completed"),
      BottomNavigationBarItem(icon: Icon(Icons.close), label: "Canceled"),
      BottomNavigationBarItem(icon: Icon(Icons.refresh), label: "Progress"),
    ],
  );
}
