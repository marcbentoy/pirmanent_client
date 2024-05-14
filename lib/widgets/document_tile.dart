import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pirmanent_client/constants.dart';
import 'package:pirmanent_client/features/pirmanent/view_doc/pages/single_doc_page.dart';
import 'package:pirmanent_client/models/document_model.dart';

class DocumentTile extends StatelessWidget {
  final Document doc;

  const DocumentTile({
    super.key,
    required this.doc,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: ButtonStyle(
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: kBorder),
          ),
        ),
        backgroundColor: MaterialStatePropertyAll(kWhite),
        padding: const MaterialStatePropertyAll(EdgeInsets.all(24)),
      ),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return SingleDocPage(
                doc: doc,
              );
            },
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // icon and status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // pdf icon
              SvgPicture.asset(getDocPDFIconPath(doc.status)),

              // status
              DocStatusWidget(status: doc.status),
            ],
          ),
          const SizedBox(
            height: 8,
          ),

          // title
          Text(
            doc.title,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: kHeadline,
            ),
          ),

          const SizedBox(
            height: 4,
          ),

          // description
          Text(
            doc.description,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: kSubheadline,
            ),
          ),

          const Spacer(),

          // separator
          const Divider(),

          // uploader name
          Text(
            doc.uploader.name,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: kContent,
            ),
          ),

          // date and time
          Text(
            doc.dateUploaded.toString(),
            style: GoogleFonts.inter(
              fontSize: 12,
              color: kSubheadline,
            ),
          ),
        ],
      ),
    );
  }
}

class DocStatusWidget extends StatelessWidget {
  final DocumentStatus status;
  const DocStatusWidget({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: getStatusColor(status, true),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // status icon
          SvgPicture.asset(getDocStatusIconPath(status)),

          const SizedBox(width: 4),

          // status text
          Text(
            getStringStatus(status),
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: getStatusColor(status, false),
            ),
          ),
        ],
      ),
    );
  }
}

String getDocStatusIconPath(DocumentStatus status) {
  switch (status) {
    case DocumentStatus.waiting:
      return "assets/icons/waiting_icon.svg";
    case DocumentStatus.signed:
      return "assets/icons/signed_icon.svg";
    case DocumentStatus.cancelled:
      return "assets/icons/cancelled_icon.svg";
    default:
      return "assets/icons/cancelled_icon.svg";
  }
}

String getDocPDFIconPath(DocumentStatus status) {
  switch (status) {
    case DocumentStatus.waiting:
      return "assets/icons/pdf_waiting_icon.svg";
    case DocumentStatus.signed:
      return "assets/icons/pdf_signed_icon.svg";
    case DocumentStatus.cancelled:
      return "assets/icons/pdf_cancelled_icon.svg";
    default:
      return "assets/icons/pdf_cancelled_icon.svg";
  }
}

String getStringStatus(DocumentStatus status) {
  switch (status) {
    case DocumentStatus.waiting:
      return "WAITING";
    case DocumentStatus.signed:
      return "SIGNED";
    case DocumentStatus.cancelled:
      return "CANCELLED";
    default:
      return "WAITING";
  }
}

Color getStatusColor(DocumentStatus status, bool isLight) {
  switch (status) {
    case DocumentStatus.waiting:
      return isLight ? kLightGreen : kDarkGreen;
    case DocumentStatus.signed:
      return isLight ? kLightBlue : kDarkBlue;
    case DocumentStatus.cancelled:
      return isLight ? kLightYellow : kDarkYellow;
    default:
      return isLight ? kLightGreen : kDarkGreen;
  }
}
