import 'package:flutter/material.dart';

class ViewProfilePage extends StatelessWidget {
  const ViewProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("View Profile Page"),
        FilledButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Log out"),
        ),
      ],
    );
  }
}
