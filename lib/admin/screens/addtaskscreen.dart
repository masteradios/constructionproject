import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hiten/models/user.dart';
import 'package:hiten/providers/userProvider.dart';
import 'package:hiten/screens/home/workerhomeScreen.dart';
import 'package:hiten/showSnackBar.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../models/task.dart';

// Define a Task class

class NewTaskScreen extends StatefulWidget {
  @override
  _NewTaskScreenState createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _taskTitle;
  bool _isLoading = false;

  void _submitTask({required String managerName}) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      // Create a new Task object
      Task newTask = Task(
          taskTitle: _taskTitle,
          managerUID: FirebaseAuth.instance.currentUser!.uid,
          createdAt: Timestamp.now(),
          isCompleted: false,
          id: Uuid().v4(),
          managerName: managerName);

      // Save the task to Firestore
      FirebaseFirestore.instance.collection('tasks').add({
        'taskTitle': newTask.taskTitle,
        'managerUID': newTask.managerUID,
        'createdAt': newTask.createdAt,
        'isCompleted': newTask.isCompleted,
        'managerName': newTask.managerName
      }).then((value) {
        setState(() {
          _isLoading = false;
        });
        // Show a success message or navigate back to previous screen
        displaySnackBar(
            context: context, content: 'Task uploaded successfully');
        Navigator.pushNamedAndRemoveUntil(
            context, WorkerHomePage.routeName, (route) => false);
      }).catchError((error) {
        // Handle error
        setState(() {
          _isLoading = false;
        });
        print('Error creating task: $error');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ModelUser user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(title: Text('Add New Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Task Title',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a task title';
                  }
                  return null;
                },
                onSaved: (newValue) => _taskTitle = newValue!,
              ),
              SizedBox(height: 20),
              _isLoading
                  ? Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey,
                      ),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : ElevatedButton(
                      onPressed: () {
                        _submitTask(managerName: user.name);
                      },
                      child: Text(
                        'Submit',
                        style: GoogleFonts.getFont('Poppins',
                            color: Colors.white, fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
