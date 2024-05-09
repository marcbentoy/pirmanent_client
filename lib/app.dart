import 'package:flutter/material.dart';
import 'package:pirmanent_client/core/shared.dart' as shared;
import 'package:pirmanent_client/features/login/pages/login.dart';
// import 'package:pirmanent_client/widgets/sidebar/sidebar.dart';

class PirmanentApp extends StatefulWidget {
  const PirmanentApp({super.key});

  @override
  State<PirmanentApp> createState() => _PirmanentAppState();
}

class _PirmanentAppState extends State<PirmanentApp> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("is logged? ${shared.isLoggedIn}"),
        LoginPage(),
      ],
    );
    // : Row(
    //     children: [
    //       CustomSidebar(),
    //       Expanded(
    //         child: Center(
    //           child: Text("Pirmanent"),
    //         ),
    //       ),
    //     ],
    //   );
  }
}
