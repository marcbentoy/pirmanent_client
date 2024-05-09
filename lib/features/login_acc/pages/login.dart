import 'package:flutter/material.dart';
import 'package:pirmanent_client/core/shared.dart' as shared;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            child: Column(
              children: [
                Text("Login Page"),
                Text("State: ${shared.isLoggedIn}"),
                FilledButton(
                  onPressed: () {
                    setState(() {
                      shared.isLoggedIn = !shared.isLoggedIn;
                    });

                    debugPrint(shared.isLoggedIn.toString());
                  },
                  child: Text("Login"),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
