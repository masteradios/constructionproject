import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String id;
  final String taskTitle;
  final String managerUID;
  final Timestamp createdAt;
  final String managerName;
  final bool isCompleted;

  Task(
      {required this.taskTitle,
      required this.managerUID,
      required this.createdAt,
      required this.managerName,
      required this.id,
      required this.isCompleted});
}
