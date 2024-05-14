import 'package:flutter/material.dart';
import 'package:pirmanent_client/features/pirmanent/sign_doc/pages/sign_doc_page.dart';
import 'package:pirmanent_client/features/pirmanent/upload_doc/pages/upload_doc_page.dart';
import 'package:pirmanent_client/features/pirmanent/view_doc/pages/private_doc_page.dart';
import 'package:pirmanent_client/features/pirmanent/view_doc/pages/public_doc_page.dart';
import 'package:pirmanent_client/features/pirmanent/view_profile/pages/view_profile_page.dart';
import 'package:pirmanent_client/widgets/sidebar/sidebar.dart';

class PirmanentApp extends StatefulWidget {
  const PirmanentApp({super.key});

  @override
  State<PirmanentApp> createState() => _PirmanentAppState();
}

class _PirmanentAppState extends State<PirmanentApp> {
  int currentPageIndex = 0;
  List<Widget> pages = [
    const PublicDocsPage(),
    const PrivateDocsPage(),
    const UploadDocPage(),
    const SignDocPage(),
    // const VerifyDocPage(),
    // const SettingsPage(),
    const ViewProfilePage(),
  ];

  void updateCurrentPageIndex(int i) {
    setState(() {
      currentPageIndex = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          CustomSidebar(
            currIndex: currentPageIndex,
            updateCurrentPageIndex: updateCurrentPageIndex,
          ),
          Expanded(
            child: pages[currentPageIndex],
          ),
        ],
      ),
    );
  }
}
