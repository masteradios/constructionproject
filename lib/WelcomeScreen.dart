import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hiten/admin/screens/AdminhomeScreen.dart';
import 'package:hiten/models/user.dart';
import 'package:hiten/screens/auth/auth.dart';
import 'package:hiten/screens/home/workerhomeScreen.dart';
import 'package:hiten/services/auth.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  ModelUser? user;
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  void getUserData() async {
    setState(() {
      isLoading = true;
    });

    user = await AuthService().getUserDetails(context: context);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            return (isLoading)
                ? Scaffold(
                    body: Center(
                      child: const CircularProgressIndicator(
                        color: Colors.green,
                      ),
                    ),
                  )
                : CheckUserRole(user: user!);
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text('${snapshot.error}'),
              ),
            );
          }
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.green,
            ),
          );
        }
        return LoginScreen();
      },
    );
  }
}

class CheckUserRole extends StatefulWidget {
  final ModelUser user;
  const CheckUserRole({super.key, required this.user});

  @override
  State<CheckUserRole> createState() => _CheckUserRoleState();
}

class _CheckUserRoleState extends State<CheckUserRole> {
  @override
  Widget build(BuildContext context) {
    return (widget.user.userType != 'worker')
        ? AdminHomePage()
        : WorkerHomePage();
  }
}
