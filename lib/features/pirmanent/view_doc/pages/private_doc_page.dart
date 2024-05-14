import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pirmanent_client/constants.dart';
import 'package:pirmanent_client/main.dart';
import 'package:pirmanent_client/models/document_model.dart';
import 'package:pirmanent_client/models/user_model.dart';
import 'package:http/http.dart' as http;

import '../../../../widgets/document_tile.dart';

class PrivateDocsPage extends StatefulWidget {
  const PrivateDocsPage({super.key});

  @override
  State<PrivateDocsPage> createState() => _PrivateDocsPageState();
}

class _PrivateDocsPageState extends State<PrivateDocsPage> {
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

  List<Document> privDocs = [];

  void getPrivDocs() async {
    final documentsResponse = await http.get(
        Uri.parse(
            'http://192.168.1.48:8090/api/collections/documents/records?filter=isPublic%3Dfalse%26%26(signer%3D%27$userId%27%7C%7Cuploader%3D%27$userId%27)'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-type': 'application/json',
        });

    if (documentsResponse.statusCode == 200) {
      final data = jsonDecode(documentsResponse.body);

      // Check if the response contains a list under a specific key
      final items = data['items'] ?? data;

      // Ensure items is a list
      if (items is List) {
        for (var item in items) {
          // get uploader data
          final uploader =
              await pb.collection('users').getOne(item['uploader'], expand: "");
          // get signer data
          final signer = await pb.collection('users').getOne(item['signer']);

          privDocs.add(Document(
            title: item['title'],
            uploader: User(
              email: uploader.data['email'],
              name: uploader.data['name'],
              publicKey: uploader.data['publicKey'],
            ),
            dateUploaded: DateTime.parse(item['created']),
            description: item['description'],
            signer: User(
              email: signer.data['email'],
              name: signer.data['name'],
              publicKey: signer.data['publicKey'],
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
          privDocs;
        });
      } else {
        print('Expected a list but got: ${items.runtimeType}');
      }
    } else {
      print('Failed to fetch collection data: ${documentsResponse.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();

    getPrivDocs();
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
              "Private Documents",
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: kHeadline,
              ),
            ),

            const SizedBox(height: 16),

            // public documents list
            Expanded(
              child: privDocs.isEmpty
                  ? Center(
                      child: Text(
                        "No private documents",
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: kSubheadline,
                        ),
                      ),
                    )
                  : GridView.builder(
                      itemCount: privDocs.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        crossAxisCount: getCrossAxisCount(),
                      ),
                      itemBuilder: (context, index) {
                        return DocumentTile(
                          doc: privDocs[index],
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
