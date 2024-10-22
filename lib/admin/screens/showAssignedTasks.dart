import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/task.dart';

class AssignedTaskScreen extends StatefulWidget {
  @override
  _AssignedTaskScreenState createState() => _AssignedTaskScreenState();
}

class _AssignedTaskScreenState extends State<AssignedTaskScreen> {
  late List<Task> _tasks;
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    setState(() {
      _isLoading = true;
    });
    final QuerySnapshot<Map<String, dynamic>> taskSnapshot =
        await FirebaseFirestore.instance
            .collection('tasks')
            .orderBy('createdAt', descending: true)
            .get();

    setState(() {
      _isLoading = false;
      _tasks = taskSnapshot.docs
          .map((doc) => Task(
                id: doc.id,
                taskTitle: doc['taskTitle'],
                managerUID: doc['managerUID'],
                isCompleted: doc['isCompleted'] ?? false,
                createdAt: doc['createdAt'],
                managerName: doc['managerName'],
              ))
          .toList();
    });
  }

  Future<void> _toggleTaskCompletion(int index) async {
    final updatedTask =
        _tasks[index].copyWith(isCompleted: !_tasks[index].isCompleted);
    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(_tasks[index].id)
        .update({'isCompleted': updatedTask.isCompleted});
    setState(() {
      _tasks[index] = updatedTask;
    });
  }

  Future<void> _deleteTask(String taskId, int index) async {
    await FirebaseFirestore.instance.collection('tasks').doc(taskId).delete();
    setState(() {
      _tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Assigned Tasks')),
      body: (_isLoading)
          ? Center(
              child: const CircularProgressIndicator(
                color: Colors.green,
              ),
            )
          : _tasks.isEmpty
              ? _buildNoTasksWidget()
              : ListView.builder(
                  itemCount: _tasks.length,
                  itemBuilder: (context, index) {
                    final task = _tasks[index];
                    return Dismissible(
                      key: Key(task.id),
                      direction: DismissDirection.startToEnd,
                      onDismissed: (direction) => _deleteTask(task.id, index),
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerLeft,
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                      child: ListTile(
                        leading: Checkbox(
                          activeColor: Colors.green,
                          value: task.isCompleted,
                          onChanged: (value) => _toggleTaskCompletion(index),
                        ),
                        title: Text(
                          task.taskTitle,
                          style: TextStyle(
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

Widget _buildNoTasksWidget() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.assignment_turned_in_outlined,
            size: 100, color: Colors.grey),
        SizedBox(height: 16),
        Text(
          'No tasks assigned',
          style: TextStyle(fontSize: 20, color: Colors.grey),
        ),
      ],
    ),
  );
}

extension TaskExtension on Task {
  Task copyWith(
      {String? id, String? taskTitle, String? managerUID, bool? isCompleted}) {
    return Task(
      id: id ?? this.id,
      taskTitle: taskTitle ?? this.taskTitle,
      managerUID: managerUID ?? this.managerUID,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt,
      managerName: managerName,
    );
  }
}
