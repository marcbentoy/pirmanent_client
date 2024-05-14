import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pirmanent_client/constants.dart';
import 'package:pirmanent_client/main.dart';
import 'package:pirmanent_client/models/document_model.dart';
import 'package:http/http.dart' as http;
import 'package:pirmanent_client/models/user_model.dart';

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

  void getSignatureRequestDocs() async {
    print("user id: $userId");
    final documentsResponse = await http.get(
        Uri.parse(
            'http://192.168.1.48:8090/api/collections/documents/records?filter=(status%3D\'waiting\'%26%26signer%3D\'$userId\')'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-type': 'application/json',
        });

    print(documentsResponse.body);

    if (documentsResponse.statusCode == 200) {
      final data = jsonDecode(documentsResponse.body);

      // Check if the response contains a list under a specific key
      final items = data['items'] ?? data;

      // Ensure items is a list
      if (items is List) {
        for (var item in items) {
          print("singer's id: ${item['signer']}");
          // get uploader data
          final uploader =
              await pb.collection('users').getOne(item['uploader'], expand: "");
          // get signer data
          final signer = await pb.collection('users').getOne(item['signer']);

          signatureRequestDocs.add(Document(
            title: item['title'],
            uploader: User(
              email: uploader.data['email'],
              name: uploader.data['name'],
            ),
            dateUploaded: DateTime.parse(item['created']),
            description: item['description'],
            signer: User(
              email: signer.data['email'],
              name: signer.data['name'],
            ),
            status: item['status'] == 'waiting'
                ? DocumentStatus.waiting
                : item['status'] == 'signed'
                    ? DocumentStatus.signed
                    : DocumentStatus.cancelled,
            uploadedDigitalSignature: item['uploadedDigitalSignature'],
          ));
        }

        setState(() {
          signatureRequestDocs;
        });
      } else {
        print('Expected a list but got: ${items.runtimeType}');
      }
    } else {
      print(
          'Failed to fetch collection data: ${documentsResponse.statusCode} ${documentsResponse.body}');
    }
  }

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
