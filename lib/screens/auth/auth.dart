import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:hiten/WelcomeScreen.dart';
import 'package:hiten/services/auth.dart';
import 'package:hiten/showSnackBar.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  SignupData? data;
  String res = '';
  Future<void> onSignup() async {
    res = await AuthService().createUser(
        email: data!.name!.trim(), password: data!.password!.trim());
    print('in si' + res);
    setState(() {});
    if (res != 'Some error occured') {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) {
        return WelcomeScreen();
      }));
    } else {
      displaySnackBar(context: context, content: res);
      print(res);
      return;
    }
  }

  Future<void> onLogin(LoginData? data) async {
    await AuthService().signInUser(
        email: data!.name!.trim(),
        password: data!.password!.trim(),
        context: context);

    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
      return WelcomeScreen();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      onSubmitAnimationCompleted: () {},
      initialAuthMode: AuthMode.signup,
      onSignup: (SignupData signUpData) {
        setState(() {
          data = signUpData!;
          onSignup();
        });
      },
      logo: AssetImage('assets/logo.png'),
      title: 'M/S SK GURBAXANI PVT LTD',
      theme: LoginTheme(
        primaryColor: Colors.lightGreen.shade400,
        bodyStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),
        titleStyle: TextStyle(color: Colors.white, fontSize: 25),
        inputTheme: buildTheme(),
      ),
      messages: LoginMessages(
        userHint: 'Enter your email',
        passwordHint: 'Enter your password',
      ),
      onLogin: (LoginData? data) {
        onLogin(data);
      },
      onRecoverPassword: (String email) {
        print('bruhh' + email);
      },
    );
  }
}

InputDecorationTheme buildTheme() {
  BorderRadius inputBorder = BorderRadius.vertical(
    bottom: Radius.circular(10.0),
    top: Radius.circular(20.0),
  );

  return InputDecorationTheme(
    filled: true,
    fillColor: Colors.purple.withOpacity(.1),
    contentPadding: EdgeInsets.zero,
    errorStyle: const TextStyle(
      color: Colors.redAccent,
      fontSize: 15,
    ),
    labelStyle: const TextStyle(fontSize: 12),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.lightGreen, width: 4),
      borderRadius: inputBorder,
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.lightGreen.shade400, width: 5),
      borderRadius: inputBorder,
    ),
    errorBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.red.shade700, width: 7),
      borderRadius: inputBorder,
    ),
    focusedErrorBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.red.shade400, width: 8),
      borderRadius: inputBorder,
    ),
    disabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.grey, width: 5),
      borderRadius: inputBorder,
    ),
  );
}
