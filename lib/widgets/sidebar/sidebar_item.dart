import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pirmanent_client/constants.dart';

class SidebarItem extends StatefulWidget {
  final int index;
  final int currIndex;
  final String title;
  final String svgIconAssetPath;
  final void Function() clickCallback;

  const SidebarItem({
    required this.title,
    required this.svgIconAssetPath,
    required this.clickCallback,
    required this.index,
    required this.currIndex,
  });

  @override
  State<SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<SidebarItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.clickCallback,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        child: Row(
          children: [
            // sidebar item icon
            SvgPicture.asset(widget.svgIconAssetPath),

            SizedBox(
              width: 8,
            ),

            // sidebar item title
            Text(
              widget.title,
              style: GoogleFonts.inter(
                color: kWhite,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
