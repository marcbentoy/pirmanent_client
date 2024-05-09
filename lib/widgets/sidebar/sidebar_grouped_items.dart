import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pirmanent_client/constants.dart';
import 'package:pirmanent_client/widgets/sidebar/sidebar_item.dart';
import 'package:pirmanent_client/widgets/sidebar/sidebar_item_model.dart';

class SidebarGroupedItems extends StatefulWidget {
  final String groupTitle;
  final List<SidebarModel> sidebarItems;
  const SidebarGroupedItems({
    super.key,
    required this.sidebarItems,
    required this.groupTitle,
  });

  @override
  State<SidebarGroupedItems> createState() => _SidebarGroupedItemsState();
}

class _SidebarGroupedItemsState extends State<SidebarGroupedItems> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.groupTitle,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: kPaleWhite,
            ),
          ),
          Column(
            children: widget.sidebarItems.map((element) {
              return SidebarItem(
                title: element.title,
                svgIconAssetPath: element.svgIconAssetPath,
                clickCallback: element.clickCallback,
                index: widget.sidebarItems.indexOf(element),
                currIndex: currentIndex,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
