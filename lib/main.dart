import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hiten/providers/userProvider.dart';
import 'package:hiten/routes.dart';
import 'package:hiten/splashScreen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => UserProvider())],
      child: MaterialApp(
          onGenerateRoute: (routeSettings) =>
              getRoute(routeSettings: routeSettings),
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
          ),
          home: SplashScreen()),
    );
  }
}
