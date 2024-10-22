import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/task.dart';

class WorkersTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assigned Tasks'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('tasks').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingWidget();
          }
          if (snapshot.hasError) {
            return _buildErrorWidget();
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return _buildNoTasksWidget();
          }
          final List<Task> tasks = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return Task(
              id: doc.id,
              taskTitle: data['taskTitle'],
              managerUID: data['managerUID'],
              createdAt: data['createdAt'],
              isCompleted: data['isCompleted'],
              managerName: data['managerName'],
            );
          }).toList();
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              List<String> parts = task.managerName.split('@');
              String managerFirstName = parts[0];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    title: Text(
                      task.taskTitle,
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      'Assigned by: ${managerFirstName}',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 15,
                      ),
                    ),
                    leading: Checkbox(
                      value: task.isCompleted,
                      onChanged: null,
                      activeColor: Colors.green,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Text('Error fetching tasks.'),
    );
  }

  Widget _buildNoTasksWidget() {
    return Center(
      child: Text(
        'No tasks assigned.',
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.grey,
        ),
      ),
    );
  }
}
