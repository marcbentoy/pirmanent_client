import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pirmanent_client/constants.dart';
import 'package:pirmanent_client/models/document_model.dart';
import 'package:pirmanent_client/widgets/custom_filled_button.dart';
import 'package:pirmanent_client/widgets/document_tile.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class SingleDocPage extends StatelessWidget {
  final Document doc;
  const SingleDocPage({super.key, required this.doc});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SizedBox(
            width: 256,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // back button
                  CustomFilledButton(
                    click: () {
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset("assets/icons/arrow_back_icon.svg"),
                        SizedBox(width: 8),
                        Text(
                          "Back",
                          style: GoogleFonts.inter(
                            color: kContent,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    width: 80,
                    backgroundColor: kDarkWhite,
                    borderColor: kBorder,
                  ),

                  SizedBox(
                    height: 8,
                  ),

                  // doc title
                  Text(
                    doc.title,
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: kHeadline,
                    ),
                  ),

                  SizedBox(
                    height: 8,
                  ),

                  // doc status
                  DocStatusWidget(status: doc.status),

                  // divider
                  Divider(),

                  // digest
                  DetailCardWidget(
                    title: "digest",
                    content: doc.uploadedDigitalSignature,
                  ),

                  SizedBox(height: 8),

                  // date uploaded
                  DetailCardWidget(
                      title: "date uploaded",
                      content: doc.dateUploaded.toString()),
                  SizedBox(height: 8),

                  // date signed
                  DetailCardWidget(
                      title: "date signed",
                      content: doc.dateSigned == null
                          ? "not yet signed"
                          : doc.dateSigned.toString()),

                  SizedBox(height: 8),
                  // uploader
                  DetailCardWidget(
                      title: "uploader", content: doc.uploader.name),

                  SizedBox(height: 8),
                  // signer
                  DetailCardWidget(title: "signer", content: doc.signer.name),
                ],
              ),
            ),
          ),

          // pdf viewer
          Expanded(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: kDarkWhite,
              padding: EdgeInsets.all(32),
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  border: Border.all(color: kBorder),
                  borderRadius: BorderRadius.circular(12),
                  color: kDarkerWhite,
                ),
                child: Column(
                  children: [
                    // header
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                              onPressed: () {}, icon: Icon(Icons.zoom_out)),
                          SizedBox(width: 8),
                          IconButton(
                              onPressed: () {}, icon: Icon(Icons.zoom_in)),
                        ],
                      ),
                    ),

                    // pdf viewer
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        color: kDarkestWhite,
                        // child: SfPdfViewer.asset("assets/documents/test.pdf"),
                        child: SfPdfViewer.file(File(
                            "C:/Users/vince/Downloads/Company-invitation-and-confirmation-for-May2024.pdf")),
                      ),
                    ),

                    // sign action
                    doc.status == DocumentStatus.waiting
                        ? Container(
                            padding: EdgeInsets.all(8),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: CustomFilledButton(
                                    backgroundColor: kRed,
                                    click: () {},
                                    child: Text(
                                      "Decline",
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: kWhite,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  flex: 6,
                                  child: CustomFilledButton(
                                    click: () {
                                      // get
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/icons/logo_icon.svg",
                                          color: kWhite,
                                          width: 14,
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          "Sign",
                                          style: GoogleFonts.inter(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: kWhite,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : SizedBox.shrink(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DetailCardWidget extends StatelessWidget {
  final String title;
  final String content;

  const DetailCardWidget({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: kBorder),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              color: kSubheadline,
            ),
          ),
          Text(
            content,
            style: GoogleFonts.inter(
              color: kHeadline,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
