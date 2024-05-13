import 'package:flutter/material.dart';
import 'package:pirmanent_client/features/auth/login_acc/pages/login_page.dart';
import 'package:pirmanent_client/features/auth/signup_acc/pages/signup_page.dart';
import 'package:pirmanent_client/features/pirmanent/pirmanent.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => LoginPage(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
        '/app': (context) => PirmanentApp(),
        '/settings': (context) => PirmanentApp(),
        '/account': (context) => PirmanentApp(),
        '/public': (context) => PirmanentApp(),
        '/private': (context) => PirmanentApp(),
        '/upload': (context) => PirmanentApp(),
        '/sign': (context) => PirmanentApp(),
        '/verify': (context) => PirmanentApp(),
      },
      // home: Scaffold(
      //   body: LoginPage(),
      // ),
    );
  }
}
