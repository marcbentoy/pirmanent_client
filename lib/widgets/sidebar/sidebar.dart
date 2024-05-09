import 'package:flutter/material.dart';
import 'package:pirmanent_client/constants.dart';
import 'package:pirmanent_client/widgets/sidebar/sidebar_grouped_items.dart';
import 'package:pirmanent_client/widgets/sidebar/sidebar_item.dart';
import 'package:pirmanent_client/widgets/sidebar/sidebar_item_model.dart';

class CustomSidebar extends StatefulWidget {
  const CustomSidebar({super.key});

  @override
  State<CustomSidebar> createState() => _CustomSidebarState();
}

class _CustomSidebarState extends State<CustomSidebar> {
  int currentIndex = 0;

  List<SidebarModel> items = [
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
      clickCallback: () {},
    ),
  ];

  var documentItems = [
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
  ];

  var actionItems = [
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
  ];

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
          // logo
          Container(
            child: Image(image: AssetImage('assets/branding/logo.png')),
          ),

          SizedBox(
            height: 24,
          ),

          SidebarGroupedItems(
            groupTitle: "Documents",
            sidebarItems: documentItems,
          ),

          SizedBox(
            height: 24,
          ),

          SidebarGroupedItems(
            groupTitle: "Actions",
            sidebarItems: actionItems,
          ),

          Spacer(),

          SidebarItem(
            title: "Settings",
            svgIconAssetPath: "assets/icons/settings_icon.svg",
            clickCallback: () {},
            index: 2,
            currIndex: currentIndex,
          ),
          SidebarItem(
            title: "Account",
            svgIconAssetPath: "assets/icons/account_icon.svg",
            clickCallback: () {},
            index: 2,
            currIndex: currentIndex,
          ),
        ],
      ),
    );
  }
}
