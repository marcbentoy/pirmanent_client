import 'package:filepicker_windows/filepicker_windows.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pirmanent_client/constants.dart';
import 'package:pirmanent_client/main.dart';
import 'package:pirmanent_client/widgets/custom_filled_button.dart';
import 'package:pirmanent_client/widgets/custom_text_field.dart';
import 'package:http/http.dart' as http;

class UploadDocPage extends StatefulWidget {
  const UploadDocPage({super.key});

  @override
  State<UploadDocPage> createState() => _UploadDocPageState();
}

class _UploadDocPageState extends State<UploadDocPage> {
  TextEditingController userEmailController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  String? selectedFilePath;

  bool isPublic = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // headline
          Text(
            "Upload Document",
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: kHeadline,
            ),
          ),

          SizedBox(
            height: 16,
          ),

          // file selection/drag & drop
          Text(
            "Document File",
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: kDarkWhite,
                  border: Border.all(color: kBorder),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    // file icon
                    SvgPicture.asset("assets/icons/pdf_icon.svg"),

                    SizedBox(
                      width: 8,
                    ),

                    // file path
                    Text(
                      selectedFilePath ?? "no file selected",
                      style: GoogleFonts.inter(),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 8,
              ),
              TextButton(
                onPressed: () {
                  final file = OpenFilePicker()
                    ..filterSpecification = {
                      'PDF(*.pdf)': '*.pdf',
                    }
                    ..defaultFilterIndex = 0
                    ..defaultExtension = 'pdf'
                    ..title = 'Select a document';

                  final result = file.getFile();
                  if (result != null) {
                    setState(() {
                      selectedFilePath = result.path;
                    });
                    debugPrint(result.path);
                  }
                },
                child: Text(
                  "Browse file",
                  style: GoogleFonts.inter(
                    color: kBlue,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(
            height: 12,
          ),

          // user selection
          Text(
            "Document Signer's email",
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          CustomTextField(controller: userEmailController),
          SizedBox(height: 12),

          // document title
          Text(
            "Document Title",
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          CustomTextField(controller: titleController),

          SizedBox(height: 12),

          // document description
          Text(
            "Document Description (optional)",
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          CustomTextField(controller: descriptionController),

          SizedBox(height: 12),

          // publicity option
          Text(
            "Accessibility Option",
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: kDarkWhite,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: kBorder),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomFilledButton(
                  backgroundColor: isPublic ? kLightBlue : kDarkWhite,
                  click: () {
                    setState(() {
                      isPublic = true;
                    });
                  },
                  child: Text(
                    "Public",
                    style: GoogleFonts.inter(
                      color: kDarkBlue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(
                  width: 4,
                ),
                CustomFilledButton(
                  backgroundColor: isPublic ? kDarkWhite : kLightRed,
                  click: () {
                    setState(() {
                      isPublic = false;
                    });
                  },
                  child: Text(
                    "Private",
                    style: GoogleFonts.inter(
                      color: kDarkRed,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 24),

          // proceed button
          Row(
            children: [
              Expanded(
                flex: 2,
                child: CustomFilledButton(
                  backgroundColor: kGreen,
                  click: () async {
                    // get file

                    // get signer id based on email

                    // create post request
                    final record = await pb.collection('documents').create(
                      body: {
                        'title': 'Sample Document upload using flutter',
                        'status': "waiting",
                        'uploader': "67quv2nnc5vktwn",
                        'signer': "o9wsff6hr1rch40",
                      },
                      files: [
                        http.MultipartFile.fromString(
                          'document', // the name of the file field
                          'example content...',
                          filename: 'example_document.txt',
                        ),
                      ],
                    );
                  },
                  child: Text(
                    "Preview",
                    style: GoogleFonts.inter(),
                  ),
                ),
              ),
              SizedBox(
                width: 4,
              ),
              Expanded(
                flex: 6,
                child: CustomFilledButton(
                  click: () async {
                    // get file

                    // get signer id based on email

                    // create post request
                    final record = await pb.collection('documents').create(
                      body: {
                        'title': 'Sample Document upload using flutter',
                        'status': "waiting",
                        'uploader': "67quv2nnc5vktwn",
                        'signer': "o9wsff6hr1rch40",
                      },
                      files: [
                        http.MultipartFile.fromString(
                          'document', // the name of the file field
                          'example content...',
                          filename: 'example_document.txt',
                        ),
                      ],
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset("assets/icons/upload_icon.svg"),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        "Upload",
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
