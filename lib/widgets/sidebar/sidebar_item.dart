import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pirmanent_client/constants.dart';

class SidebarItem extends StatefulWidget {
  final int index;
  final int currIndex;
  final String title;
  final String svgIconAssetPath;
  final int? notifications;
  final void Function(int) updateCurrentPageIndex;

  const SidebarItem({
    required this.title,
    required this.svgIconAssetPath,
    required this.updateCurrentPageIndex,
    required this.index,
    required this.currIndex,
    this.notifications,
  });

  @override
  State<SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<SidebarItem> {
  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: ButtonStyle(
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        backgroundColor: MaterialStatePropertyAll(
            widget.index == widget.currIndex ? kPaleBlue : kBlack),
        padding: const MaterialStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      ),
      onPressed: () {
        widget.updateCurrentPageIndex(widget.index);
      },
      child: Row(
        children: [
          // icon
          SvgPicture.asset(widget.svgIconAssetPath),

          // spacing
          const SizedBox(
            width: 8,
          ),

          // sidebar item title
          Text(
            widget.title,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: kDarkWhite,
            ),
          ),

          const Spacer(),

          // notification
          widget.notifications != null && widget.notifications! > 0
              ? Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: kRed,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      widget.notifications.toString(),
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: kWhite,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
    // return GestureDetector(
    //   onTap: widget.clickCallback,
    //   child: Container(
    //     padding: EdgeInsets.symmetric(
    //       horizontal: 12,
    //       vertical: 8,
    //     ),
    //     child: Row(
    //       children: [
    //         // sidebar item icon
    //         SvgPicture.asset(widget.svgIconAssetPath),

    //         SizedBox(
    //           width: 8,
    //         ),

    //         // sidebar item title
    //         Text(
    //           widget.title,
    //           style: GoogleFonts.inter(
    //             color: kWhite,
    //             fontSize: 12,
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
