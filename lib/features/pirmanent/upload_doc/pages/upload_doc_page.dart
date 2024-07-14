import 'dart:convert';
import 'dart:io';

import 'package:cryptography/cryptography.dart';
import 'package:filepicker_windows/filepicker_windows.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pirmanent_client/logger/logger.dart';
import 'package:pirmanent_client/utils.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'package:pirmanent_client/constants.dart';
import 'package:pirmanent_client/core/crypto_utils.dart';
import 'package:pirmanent_client/main.dart';
import 'package:pirmanent_client/widgets/custom_filled_button.dart';
import 'package:pirmanent_client/widgets/custom_text_field.dart';
import 'package:pirmanent_client/widgets/snackbars.dart';

class UploadDocPage extends StatefulWidget {
  const UploadDocPage({super.key});

  @override
  State<UploadDocPage> createState() => _UploadDocPageState();
}

class _UploadDocPageState extends State<UploadDocPage> {
  TextEditingController userEmailController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  final logger = MarkedLog();

  String? selectedFilePath;
  String? selectedFilename;
  File? selectedFile;

  bool isPublic = false;

  late Signature digitalSignature;

  void addPageToPdf(PdfDocument document) {
    final String paragraphText = 'uploaded by: ${userData.name},'
        'date: ${DateTime.now()}';

    final PdfPage page = document.pages.add();
    final PdfLayoutResult newlayoutResult = PdfTextElement(
            text: paragraphText,
            font: PdfStandardFont(PdfFontFamily.helvetica, 12),
            brush: PdfSolidBrush(PdfColor(0, 0, 0)))
        .draw(
            page: page,
            bounds: Rect.fromLTWH(
                0, 0, page.getClientSize().width, page.getClientSize().height),
            format: PdfLayoutFormat(layoutType: PdfLayoutType.paginate))!;

    // Draw the next paragraph/content.
    page.graphics.drawLine(
        PdfPen(PdfColor(255, 0, 0)),
        Offset(0, newlayoutResult.bounds.bottom + 10),
        Offset(page.getClientSize().width, newlayoutResult.bounds.bottom + 10));
  }

  Future<void> savePdfToDocsPath(PdfDocument document) async {
    final documentsDir = await getApplicationDocumentsDirectory();
    final Directory documentsAppDir =
        Directory(p.join(documentsDir.path, 'pirmanent'));

    if (!(await documentsAppDir.exists())) {
      await documentsAppDir.create(recursive: true);
    }

    final savedFilePath = p.join(documentsAppDir.path, selectedFilename);
    await File(savedFilePath).writeAsBytes(await document.save());
    document.dispose();

    selectedFile = File(savedFilePath);
  }

  void clearUploadDocForm() {
    setState(() {
      selectedFilePath = "no file selected";
      userEmailController.clear();
      titleController.clear();
      descriptionController.clear();
    });
  }

  void uploadDoc(PocketBase pb, dynamic signerId) {
    pb.collection('documents').create(
      body: {
        'title': titleController.text,
        'status': 'waiting',
        'uploader': userId,
        'description': descriptionController.text,
        'signer': signerId,
        'uploadedDigitalSignature': intsToHexString(digitalSignature.bytes),
        'isPublic': isPublic,
        'isVerified': false,
      },
      files: [
        http.MultipartFile.fromBytes(
          'uploadedFile', // the name of the file field
          selectedFile!.readAsBytesSync(),
          filename: selectedFilename,
        ),
      ],
    ).then((record) {
      logger.info("document post request success!");
      logger.info(record.id);
      logger.info(record.getStringValue('title'));
    });
  }

  Future<void> signDocument() async {
    final documentsDir = await getApplicationDocumentsDirectory();

    final savedFilePath =
        p.join(documentsDir.path, 'pirmanent', selectedFilename);
    final message = await File(savedFilePath).readAsBytes();
    final algorithm = Ed25519();

    final keyPair = await retrieveKeyPair(userData);
    logger.info(
        "signer priv key: ${intsToHexString(await keyPair.extractPrivateKeyBytes())}");
    var extractedPubKey = await keyPair.extractPublicKey();
    logger.info("signer pub key: ${intsToHexString(extractedPubKey.bytes)}");
    digitalSignature = await algorithm.sign(message, keyPair: keyPair);
  }

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

          const SizedBox(
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
          const SizedBox(height: 4),
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: kDarkWhite,
                  border: Border.all(color: kBorder),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    // file icon
                    SvgPicture.asset("assets/icons/pdf_icon.svg"),

                    const SizedBox(
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
              const SizedBox(
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

                  selectedFile = file.getFile();

                  if (selectedFile != null) {
                    logger
                        .info("File selected: ${basename(selectedFile!.path)}");
                    logger.info("File full path: ${selectedFile!.path}");

                    setState(() {
                      selectedFilePath = selectedFile?.path;
                      selectedFilename = basename(selectedFile!.path);
                    });
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

          const SizedBox(
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
          const SizedBox(height: 12),

          // document title
          Text(
            "Document Title",
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          CustomTextField(controller: titleController),

          const SizedBox(height: 12),

          // document description
          Text(
            "Document Description (optional)",
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          CustomTextField(controller: descriptionController),

          const SizedBox(height: 12),

          // publicity option
          Text(
            "Accessibility Option",
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),

          Container(
            padding: const EdgeInsets.all(4),
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
                const SizedBox(
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

          const SizedBox(height: 24),

          // proceed button
          CustomFilledButton(
            width: double.infinity,
            click: () async {
              try {
                logger.info("Starting upload process");

                // get pdf
                logger.info("Getting selected pdf file");
                final PdfDocument document = PdfDocument(
                  inputBytes: File(selectedFilePath!).readAsBytesSync(),
                );

                // add page to pdf
                logger.info("adding a page to pdf file");
                addPageToPdf(document);

                // save edited pdf
                logger.info("saving pdf file");
                await savePdfToDocsPath(document);

                // sign document base on user's private key
                logger.info("signing document");
                await signDocument();

                final pbUrl = await getPbUrl();

                // get signer id base on email
                logger.info("getting signer id based on entered email");
                final recordEndpoint =
                    '$pbUrl/api/collections/users/records?filter=email=\'${userEmailController.text}\'';
                final recordResponse = await http.get(
                  Uri.parse(recordEndpoint),
                  headers: {'Content-type': 'application/json'},
                );

                print(digitalSignature.toString());

                if (recordResponse.statusCode == 200) {
                  logger.info(
                      "get signer id request success: ${recordResponse.statusCode}");

                  final records = jsonDecode(recordResponse.body);
                  print("records: $records");
                  print("records id: ${records['items'][0]['id']}");
                  final signerId = records['items'][0]['id'];

                  final pb = PocketBase(pbUrl);

                  // create post request
                  uploadDoc(pb, signerId);

                  logger.info("Document upload success");

                  ScaffoldMessenger.of(context)
                      .showSnackBar(uploadSuccessSnackbar);

                  clearUploadDocForm();
                } else {
                  logger.error(
                      "Error requesting signer id: ${recordResponse.statusCode}");

                  ScaffoldMessenger.of(context)
                      .showSnackBar(uploadErrorSnackbar);
                }
              } catch (e) {
                logger.error("Error uploading file: ${e.toString()}");
                debugPrint(e.toString());

                ScaffoldMessenger.of(context).showSnackBar(uploadErrorSnackbar);
              }
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset("assets/icons/upload_icon.svg"),
                const SizedBox(
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
        ],
      ),
    );
  }
}
