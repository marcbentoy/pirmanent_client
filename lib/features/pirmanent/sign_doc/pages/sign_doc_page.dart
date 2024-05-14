import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pirmanent_client/constants.dart';
import 'package:pirmanent_client/models/document_model.dart';

import '../../../../widgets/document_tile.dart';

class SignDocPage extends StatefulWidget {
  const SignDocPage({super.key});

  @override
  State<SignDocPage> createState() => _SignDocPageState();
}

class _SignDocPageState extends State<SignDocPage> {
  TextEditingController searchDocController = TextEditingController();

  int getCrossAxisCount() {
    var sWidth = MediaQuery.of(context).size.width;

    return sWidth > 1400
        ? 5
        : sWidth > 1200
            ? 4
            : sWidth > 928
                ? 3
                : 2;
  }

  List<Document> signatureRequestDocs = [];

  void getSignatureRequestDocs() {}

  @override
  void initState() {
    super.initState();

    getSignatureRequestDocs();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 200,
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // headline
            Text(
              "Signature Requests",
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: kHeadline,
              ),
            ),
            Text(
              "Select a document to sign",
              style: GoogleFonts.inter(
                fontSize: 14,
                color: kHeadline,
                // fontStyle: FontStyle.italic,
              ),
            ),

            const SizedBox(height: 16),

            // public documents list
            Expanded(
              child: signatureRequestDocs.isEmpty
                  ? Center(
                      child: Text(
                        "No document that needs signature",
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: kSubheadline,
                        ),
                      ),
                    )
                  : GridView.builder(
                      itemCount: signatureRequestDocs.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        crossAxisCount: getCrossAxisCount(),
                      ),
                      itemBuilder: (context, index) {
                        return DocumentTile(
                          doc: signatureRequestDocs[index],
                        );
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }
}
