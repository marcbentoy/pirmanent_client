import 'dart:convert';
import 'dart:io';

import 'package:cryptography/cryptography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pirmanent_client/constants.dart';
import 'package:pirmanent_client/core/crypto_utils.dart';
import 'package:pirmanent_client/main.dart';
import 'package:pirmanent_client/models/document_model.dart';
import 'package:pirmanent_client/utils.dart';
import 'package:pirmanent_client/widgets/custom_filled_button.dart';
import 'package:pirmanent_client/widgets/document_tile.dart';
import 'package:pirmanent_client/widgets/snackbars.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:http/http.dart' as http;

class SingleDocPage extends StatefulWidget {
  final Document doc;
  final String? localPath;

  const SingleDocPage({
    super.key,
    required this.doc,
    this.localPath,
  });

  @override
  State<SingleDocPage> createState() => _SingleDocPageState();
}

class _SingleDocPageState extends State<SingleDocPage> {
  late String fileUrl;

  void getFileUrl() async {
    final pbUrl = await getPbUrl();
    final pb = PocketBase(pbUrl);

    final record = await pb.collection('documents').getOne(widget.doc.docId);
    String firstFilename;

    if (widget.doc.status == DocumentStatus.waiting) {
      firstFilename = record.getListValue<String>('uploadedFile')[0];
      print(firstFilename);
    } else {
      firstFilename = record.getListValue<String>('signedFile')[0];
      print(firstFilename);
    }
    print(firstFilename);

    setState(() {
      fileUrl = pb.files.getUrl(record, firstFilename).toString();
    });
  }

  @override
  void initState() {
    super.initState();

    getFileUrl();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SizedBox(
            width: 256,
            child: SingleChildScrollView(
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
                      widget.doc.title,
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
                    DocStatusWidget(status: widget.doc.status),

                    // divider
                    Divider(),

                    // digest
                    DetailCardWidget(
                      title: "upload digest",
                      content: widget.doc.uploadedDigitalSignature,
                    ),
                    SizedBox(height: 8),

                    DetailCardWidget(
                      title: "signed digest",
                      content:
                          widget.doc.signedDigitalSignature ?? "not yet signed",
                    ),

                    SizedBox(height: 8),

                    // date uploaded
                    DetailCardWidget(
                        title: "date uploaded",
                        content: widget.doc.dateUploaded.toString()),
                    SizedBox(height: 8),

                    // date signed
                    DetailCardWidget(
                        title: "date signed",
                        content: widget.doc.dateSigned == null
                            ? "not yet signed"
                            : widget.doc.dateSigned.toString()),

                    SizedBox(height: 8),
                    // uploader
                    DetailCardWidget(
                        title: "uploader", content: widget.doc.uploader.name),

                    SizedBox(height: 8),
                    // signer
                    DetailCardWidget(
                        title: "signer", content: widget.doc.signer.name),

                    SizedBox(height: 8),
                    // signer
                    DetailCardWidget(
                        title: "Is verified?",
                        content: widget.doc.isVerified == false
                            ? "not verified"
                            : "Verfied"),
                  ],
                ),
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
                    // pdf viewer
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        color: kDarkestWhite,
                        // child: SfPdfViewer.asset("assets/documents/test.pdf"),
                        child: SfPdfViewer.network(fileUrl),
                      ),
                    ),

                    // sign action
                    widget.doc.status == DocumentStatus.waiting &&
                            widget.doc.signer.email == userData.email &&
                            userData.fingerprintId == null
                        ? Container(
                            padding: EdgeInsets.all(8),
                            child: CustomFilledButton(
                              click: () async {
                                // get file
                                final directory = await getTemporaryDirectory();
                                final filePath =
                                    '${directory.path}/${widget.doc.title}';
                                final response =
                                    await http.get(Uri.parse(fileUrl));

                                // Check if the response is successful
                                if (response.statusCode == 200) {
                                  // Write the file to the temporary directory
                                  final file = File(filePath);
                                  await file.writeAsBytes(response.bodyBytes);

                                  final PdfDocument document = PdfDocument(
                                    inputBytes: file.readAsBytesSync(),
                                  );

                                  // edit file
                                  final String paragraphText =
                                      'signed by: ${userData.name},'
                                      'date: ${DateTime.now()}';
                                  final PdfPage page = document.pages.add();
                                  final PdfLayoutResult newlayoutResult =
                                      PdfTextElement(
                                              text: paragraphText,
                                              font: PdfStandardFont(
                                                  PdfFontFamily.helvetica, 12),
                                              brush: PdfSolidBrush(
                                                  PdfColor(0, 0, 0)))
                                          .draw(
                                              page: page,
                                              bounds: Rect.fromLTWH(
                                                  0,
                                                  0,
                                                  page.getClientSize().width,
                                                  page.getClientSize().height),
                                              format: PdfLayoutFormat(
                                                  layoutType:
                                                      PdfLayoutType.paginate))!;

                                  // Draw the next paragraph/content.
                                  document
                                      .pages[document.pages.count - 1].graphics
                                      .drawLine(
                                          PdfPen(PdfColor(255, 0, 0)),
                                          Offset(
                                              0,
                                              newlayoutResult.bounds.bottom +
                                                  10),
                                          Offset(
                                              document.pages[
                                                      document.pages.count - 1]
                                                  .getClientSize()
                                                  .width,
                                              newlayoutResult.bounds.bottom +
                                                  10));

                                  // save edited pdf
                                  File("${widget.doc.title}.pdf")
                                      .writeAsBytes(await document.save());
                                  document.dispose();

                                  File editedFile =
                                      File("${widget.doc.title}.pdf");

                                  // generate digital signature
                                  final message =
                                      await editedFile.readAsBytes();
                                  final algorithm = Ed25519();

                                  final keyPair =
                                      await retrieveKeyPair(userData);
                                  print(intsToHexString(
                                      await keyPair.extractPrivateKeyBytes()));
                                  var extractedPubKey =
                                      await keyPair.extractPublicKey();
                                  print(intsToHexString(extractedPubKey.bytes));
                                  var digitalSignature = await algorithm
                                      .sign(message, keyPair: keyPair);

                                  final pbUrl = await getPbUrl();

                                  // get uploader id base from email
                                  final recordEndpoint =
                                      '$pbUrl/api/collections/users/records?filter=email=\'${widget.doc.uploader.email}\'';
                                  final recordResponse = await http.get(
                                    Uri.parse(recordEndpoint),
                                    headers: {
                                      'Content-type': 'application/json'
                                    },
                                  );
                                  final records =
                                      jsonDecode(recordResponse.body);
                                  print("records: ${records}");
                                  print(
                                      "records id: ${records['items'][0]['id']}");
                                  final uploaderId = records['items'][0]['id'];

                                  // update
                                  final body = <String, dynamic>{
                                    "title": widget.doc.title,
                                    "description": widget.doc.description,
                                    "status": 'signed',
                                    "uploader": uploaderId,
                                    "signer": userId,
                                    "uploadedDigitalSignature":
                                        widget.doc.uploadedDigitalSignature,
                                    "signedDigitalSignature":
                                        intsToHexString(digitalSignature.bytes),
                                    "dateSigned": DateTime.now().toString(),
                                    "isVerified": true,
                                  };

                                  final pb = PocketBase(pbUrl);

                                  await pb.collection('documents').update(
                                    widget.doc.docId,
                                    body: body,
                                    files: [
                                      http.MultipartFile.fromBytes(
                                        'signedFile', // the name of the file field
                                        File("${widget.doc.title}.pdf")
                                            .readAsBytesSync(),
                                        filename: "${widget.doc.title}.pdf",
                                      ),
                                    ],
                                  );

                                  // create post request for verification request
                                  final postRequstBody = <String, dynamic>{
                                    "vDeviceId": "PRM0001",
                                    "document": widget.doc.docId,
                                    "status": 'signed',
                                  };

                                  await pb
                                      .collection('documentRequests')
                                      .create(body: postRequstBody);

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(signSuccessSnackbar);

                                  Navigator.pop(context);
                                } else {
                                  throw Exception('Failed to download file');
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
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
                                    "Sign Document",
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: kWhite,
                                    ),
                                  ),
                                ],
                              ),
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
