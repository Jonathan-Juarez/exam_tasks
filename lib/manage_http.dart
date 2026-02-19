import 'package:exam_tasks/home_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:./http_response_manager.dart';
import 'dart:convert';

String uri = 'http://10.219.251.54:3010'; // IP de la computadora o servidor

// Modelo de tabla task
class TaskTable {
  final String id;
  final String title;
  final String description;
  final String dueDate;
  final String priority;
  final String status;
  final bool recurringTask;
  final String createdAt;

  TaskTable({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    required this.status,
    required this.recurringTask,
    required this.createdAt,
  });

  // Serialización: Convertir objeto a map
  // Un mapa es un calección de datos llave-valor
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate,
      'priority': priority,
      'status': status,
      'recurringTask': recurringTask,
      'createdAt': createdAt,
    };
  }

  String toJson() => json.encode(toMap());
  factory TaskTable.fromMap(Map<String, dynamic> map) {
    return TaskTable(
      id: (map['_id'] ?? map['id'] ?? '').toString(),
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      dueDate: map['dueDate'] as String? ?? '',
      priority: map['priority'] as String? ?? '',
      status: map['status'] as String? ?? '',
      recurringTask: map['recurringTask'] is int
          ? (map['recurringTask'] == 1)
          : (map['recurringTask'] as bool? ?? false),
      createdAt: map['createdAt'] as String? ?? '',
    );
  }

  factory TaskTable.fromJson(String source) =>
      TaskTable.fromMap(json.decode(source) as Map<String, dynamic>);
}

// Function to show the http code status
void manageHTTPResponse({
  required http.Response response,
  required BuildContext context,
  required VoidCallback onSuccess,
}) {
  switch (response.statusCode) {
    case 200:
      onSuccess();
      break;
    case 400:
      showSnackbar(context, json.decode(response.body)['message']);
      break;
    case 500:
      showSnackbar(context, json.decode(response.body)['message']);
      break;
    case 201:
      onSuccess();
      break;
    case 404:
      showSnackbar(context, json.decode(response.body)['message']);
      break;
  }
}

void showSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

// The main API comunicator
class TaskHTTPManager {
  // Get task list recurring
  Future<List<TaskTable>> getTasksRecurring({
    required BuildContext context,
  }) async {
    try {
      final http.Response response = await http.get(
        Uri.parse('$uri/api/tasks/recurring'),
        // body: "e",
        headers: <String, String>{
          'Content-type': 'application/json; charset=UTF-8',
        },
      );
      List<TaskTable> tasks = [];

      manageHTTPResponse(
        response: response,
        context: context,
        onSuccess: () {
          showSnackbar(context, 'Task list successfully recurring');
          final List<dynamic> data = json.decode(response.body);

          tasks = data.map((e) => TaskTable.fromMap(e)).toList();
        },
      );
      return tasks;
    } catch (e) {
      debugPrint(e.toString());
      showSnackbar(context, e.toString());
      return [];
    }
  }

  // Get task list completed
  Future<List<TaskTable>> getTasksCompleted({
    required BuildContext context,
  }) async {
    try {
      final http.Response response = await http.get(
        Uri.parse('$uri/api/tasks/completed'),
        // body: "e",
        headers: <String, String>{
          'Content-type': 'application/json; charset=UTF-8',
        },
      );
      List<TaskTable> tasks = [];

      manageHTTPResponse(
        response: response,
        context: context,
        onSuccess: () {
          showSnackbar(context, 'Task list successfully completed');
          final List<dynamic> data = json.decode(response.body);
          if (data.isNotEmpty) {
            print('First task raw data: ${data.first}');
          }
          tasks = data.map((e) => TaskTable.fromMap(e)).toList();
        },
      );
      return tasks;
    } catch (e) {
      debugPrint(e.toString());
      showSnackbar(context, e.toString());
      return [];
    }
  }

  // Posts or insert a task
  Future<void> postTask({
    required BuildContext context,
    required String id,
    required String title,
    required String description,
    required String dueDate,
    required String priority,
    required String status,
    required bool recurringTask,
    required String createdAt,
  }) async {
    try {
      final TaskTable taskTable = TaskTable(
        id: '',
        title: title,
        description: description,
        dueDate: dueDate,
        priority: priority,
        status: status,
        recurringTask: recurringTask,
        createdAt: '',
      );

      final http.Response response = await http.post(
        Uri.parse('$uri/api/tasks'),
        body: taskTable.toJson(),
        headers: <String, String>{
          'Content-type': 'application/json; charset=UTF-8',
        },
      );

      manageHTTPResponse(
        response: response,
        context: context,
        onSuccess: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
          showSnackbar(context, 'Task list successfully fetched');
        },
      );
    } catch (e) {
      debugPrint(e.toString());
      showSnackbar(context, e.toString());
    }
  }

  // Updates a specific task
  Future<void> updateTask({
    required BuildContext context,
    required String id,
    required int recurringTask,
  }) async {
    try {
      // final TaskTable taskTable = TaskTable(
      //   id: id,
      //   title: title,
      //   description: description,
      //   dueDate: '',
      //   priority: '',
      //   status: status,
      //   recurringTask: recurringTask,
      //   createdAt: '',
      // );
      debugPrint("Método update:$id");
      debugPrint("Método update:$recurringTask");

      final http.Response response = await http.put(
        Uri.parse('$uri/api/tasks/$id/$recurringTask'),
        headers: <String, String>{
          'Content-type': 'application/json; charset=UTF-8',
        },
      );

      manageHTTPResponse(
        response: response,
        context: context,
        onSuccess: () {
          showSnackbar(context, 'Task list successfully fetched');
        },
      );
    } catch (e) {
      debugPrint(e.toString());
      showSnackbar(context, e.toString());
    }
  }

  // Deletes a specific task
  Future<void> deleteTask({
    required BuildContext context,
    required String id,
    // required String title,
    // required String description,
    // required String dueDate,
    // required String priority,
    // required String status,
    // required String recurringTask,
    // required String createdAt,
  }) async {
    try {
      // final TaskTable taskTable = TaskTable(
      //   id: '',
      //   title: '',
      //   description: '',
      //   dueDate: '',
      //   priority: '',
      //   status: '',
      //   recurringTask: '',
      //   createdAt: ''
      // );
      debugPrint("Método delete:$id");

      final http.Response response = await http.delete(
        Uri.parse('$uri/api/tasks/$id'),
        headers: <String, String>{
          'Content-type': 'application/json; charset=UTF-8',
        },
      );

      // Revisa si el contexto sigue montado.
      if (!context.mounted) return;

      manageHTTPResponse(
        response: response,
        context: context,
        onSuccess: () {
          showSnackbar(context, 'Task list successfully delete');
        },
      );
    } catch (e) {
      debugPrint(e.toString());
      showSnackbar(context, e.toString());
    }
  }
}
