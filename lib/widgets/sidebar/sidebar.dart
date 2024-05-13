import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pirmanent_client/constants.dart';
import 'package:pirmanent_client/widgets/sidebar/sidebar_item.dart';
import 'package:pirmanent_client/widgets/sidebar/sidebar_item_model.dart';

class CustomSidebar extends StatefulWidget {
  final void Function(int) updateCurrentPageIndex;
  final int currIndex;

  const CustomSidebar({
    super.key,
    required this.updateCurrentPageIndex,
    required this.currIndex,
  });

  @override
  State<CustomSidebar> createState() => _CustomSidebarState();
}

class _CustomSidebarState extends State<CustomSidebar> {
  List<SidebarModel> items = [];

  @override
  void initState() {
    super.initState();
    items = [
      SidebarModel(
        title: "Public Documents",
        svgIconAssetPath: "assets/icons/public_icon.svg",
        clickCallback: () {},
      ),
      SidebarModel(
        title: "Private Documents",
        svgIconAssetPath: "assets/icons/private_icon.svg",
        clickCallback: () {},
      ),
      SidebarModel(
        title: "Upload",
        svgIconAssetPath: "assets/icons/upload_icon.svg",
        clickCallback: () {},
      ),
      SidebarModel(
        title: "Sign",
        svgIconAssetPath: "assets/icons/sign_icon.svg",
        clickCallback: () {},
      ),
      SidebarModel(
        title: "Verify",
        svgIconAssetPath: "assets/icons/verify_icon.svg",
        clickCallback: () {},
      ),
      SidebarModel(
        title: "Settings",
        svgIconAssetPath: "assets/icons/settings_icon.svg",
        clickCallback: () {},
      ),
      SidebarModel(
        title: "Account",
        svgIconAssetPath: "assets/icons/account_icon.svg",
        clickCallback: () {
          debugPrint("trying to pop a navigation");
          Navigator.pop(context);
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: kBlack,
      ),
      width: 200,
      child: Column(
        children: [
          Container(
            child: Image(image: AssetImage('assets/branding/logo.png')),
          ),
          SizedBox(
            height: 24,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: renderSidebar(),
          ),
        ],
      ),
    );
  }

  List<Widget> renderSidebar() {
    List<Widget> sidebar = [];

    for (int i = 0; i < items.length; i++) {
      var curr = items[i];
      sidebar.add(
        SidebarItem(
          title: curr.title,
          svgIconAssetPath: curr.svgIconAssetPath,
          updateCurrentPageIndex: widget.updateCurrentPageIndex,
          index: i,
          currIndex: widget.currIndex,
        ),
      );
    }

    sidebar.insert(
      0,
      Column(
        children: [
          Text(
            "Documents",
            style: GoogleFonts.inter(
              fontSize: 12,
              color: kPaleWhite,
            ),
          ),
          SizedBox(height: 4),
        ],
      ),
    );

    sidebar.insert(
      3,
      Column(
        children: [
          SizedBox(height: 16),
          Text(
            "Actions",
            style: GoogleFonts.inter(
              fontSize: 12,
              color: kPaleWhite,
            ),
          ),
          SizedBox(height: 4),
        ],
      ),
    );

    sidebar.insert(
      7,
      Column(
        children: [
          SizedBox(height: 16),
          Text(
            "System",
            style: GoogleFonts.inter(
              fontSize: 12,
              color: kPaleWhite,
            ),
          ),
          SizedBox(height: 4),
        ],
      ),
    );

    return sidebar;
  }
}
