import 'dart:convert';
import 'dart:io';
import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart';

import 'package:filepicker_windows/filepicker_windows.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pirmanent_client/constants.dart';
import 'package:pirmanent_client/core/crypto_utils.dart';
import 'package:pirmanent_client/main.dart';
import 'package:pirmanent_client/widgets/custom_filled_button.dart';
import 'package:pirmanent_client/widgets/custom_text_field.dart';
import 'package:http/http.dart' as http;
import 'package:pirmanent_client/widgets/snackbars.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

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
  String? selectedFilename;
  File? selectedFile;

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

                  selectedFile = file.getFile();
                  if (selectedFile != null) {
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
                    try {
                      // get pdf
                      final PdfDocument document = PdfDocument(
                        inputBytes: File(selectedFilePath!).readAsBytesSync(),
                      );

                      // add page to pdf
                      document.pages.add().graphics.drawString(
                          "uploaded by: ${userData.name}",
                          PdfStandardFont(PdfFontFamily.helvetica, 12),
                          brush: PdfSolidBrush(PdfColor(0, 0, 0)),
                          bounds: const Rect.fromLTWH(0, 0, 150, 20));

                      document.pages.add().graphics.drawString(
                          "date: ${DateTime.now()}",
                          PdfStandardFont(PdfFontFamily.helvetica, 12),
                          brush: PdfSolidBrush(PdfColor(0, 0, 0)),
                          bounds: const Rect.fromLTWH(0, 0, 150, 20));

                      // save edited pdf
                      File(selectedFilename!)
                          .writeAsBytes(await document.save());
                      document.dispose();

                      // sign document base on user's private key
                      final message =
                          await File(selectedFilename!).readAsBytes();
                      final algorithm = Ed25519();

                      final keyPair = await retrieveKeyPair();
                      print(intsToHexString(
                          await keyPair.extractPrivateKeyBytes()));
                      var extractedPubKey = await keyPair.extractPublicKey();
                      print(intsToHexString(extractedPubKey.bytes));
                      final digitalSignature =
                          await algorithm.sign(message, keyPair: keyPair);

                      // get signer id base on email
                      final recordEndpoint =
                          'http://192.168.1.48:8090/api/collections/users/records?filter=email=\'${userEmailController.text}\'';
                      final recordResponse = await http.get(
                        Uri.parse(recordEndpoint),
                        headers: {'Content-type': 'application/json'},
                      );

                      print(digitalSignature.toString());

                      if (recordResponse.statusCode == 200) {
                        final records = jsonDecode(recordResponse.body);
                        print("records: ${records}");
                        print("records id: ${records['items'][0]['id']}");
                        final signerId = records['items'][0]['id'];

                        // create post request
                        pb.collection('documents').create(
                          body: {
                            'title': titleController.text,
                            'status': 'waiting',
                            'uploader': userId,
                            'signer': signerId,
                            'uploadedDigitalSignature':
                                intsToHexString(digitalSignature.bytes),
                          },
                          files: [
                            http.MultipartFile.fromBytes(
                              'uploadedFile', // the name of the file field
                              selectedFile!.readAsBytesSync(),
                              filename: selectedFilename,
                            ),
                          ],
                        ).then((record) {
                          print(record.id);
                          print(record.getStringValue('title'));
                        });

                        ScaffoldMessenger.of(context)
                            .showSnackBar(uploadSuccessSnackbar);
                      } else {
                        // TODO: show error upload snackbar
                        ScaffoldMessenger.of(context)
                            .showSnackBar(uploadErrorSnackbar);
                      }
                    } catch (e) {
                      print(e);
                      ScaffoldMessenger.of(context)
                          .showSnackBar(uploadErrorSnackbar);
                    }
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

  Future<SimpleKeyPair> retrieveKeyPair() async {
    final storage = FlutterSecureStorage();

    final privateKeyString = await storage.read(key: userData.email);
    print("priv key from secure storage: $privateKeyString");

    if (privateKeyString == null) {
      throw Exception('Key pair not found');
    }

    final privateKeyBytes = hexStringToInts(privateKeyString);
    final publicKeyBytes = hexStringToInts(userData.publicKey);

    return SimpleKeyPairData(privateKeyBytes,
        publicKey: SimplePublicKey(publicKeyBytes, type: KeyPairType.ed25519),
        type: KeyPairType.ed25519);
  }
}
