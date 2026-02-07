import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task_model.dart';
import '../app_url.dart';
import 'auth_controller.dart';

class TaskController {

  static Map<String, String> get _headers => {
    "token": AuthController.accessToken!,
    "Content-Type": "application/json",
  };

  static Future<List<TaskModel>> fetchTasks(String status) async {
    final res = await http.get(
      Uri.parse("${AppUrl.listTaskByStatus}/$status"),
      headers: _headers,
    );

    final data = jsonDecode(res.body);
    return List<TaskModel>.from(
      data['data'].map((e) => TaskModel.fromJson(e)),
    );
  }


  static Future<bool> addTask(String title, String description) async {
    final res = await http.post(
      Uri.parse(AppUrl.createTask),
      headers: _headers,
      body: jsonEncode({
        "title": title,
        "description": description,
        "status": "New",
      }),
    );
    return res.statusCode == 200;
  }

  static Future<bool> updateTask(
  String id,
  String title,
  String description,
  String status,
) async {
  final res = await http.post(
    Uri.parse("${AppUrl.updateTaskStatus}/$id/$status"),
    headers: _headers,
    body: jsonEncode({
      "title": title,
      "description": description,
    }),
  );

  return res.statusCode == 200;
}



  static Future<void> updateStatus(String id, String status) async {
    await http.get(
      Uri.parse("${AppUrl.updateTaskStatus}/$id/$status"),
      headers: _headers,
    );
  }

 
  static Future<void> deleteTask(String id) async {
    await http.get(
      Uri.parse("${AppUrl.deleteTask}/$id"),
      headers: _headers,
    );
  }

  static Future<Map<String, int>> statusCount() async {
    final res = await http.get(
      Uri.parse(AppUrl.taskStatusCount),
      headers: _headers,
    );

    final data = jsonDecode(res.body);
    Map<String, int> map = {};
    for (var item in data['data']) {
      map[item['_id']] = item['sum'];
    }
    return map;
  }
}
