import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pirmanent_client/constants.dart';
import 'package:pirmanent_client/widgets/custom_filled_button.dart';
import 'package:pirmanent_client/widgets/custom_text_field.dart';

class PublicDocsPage extends StatefulWidget {
  const PublicDocsPage({super.key});

  @override
  State<PublicDocsPage> createState() => _PublicDocsPageState();
}

class _PublicDocsPageState extends State<PublicDocsPage> {
  TextEditingController searchDocController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 200,
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // headline
              Text(
                "Public Documents",
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: kHeadline,
                ),
              ),

              SizedBox(
                height: 8,
              ),

              // search box
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: searchDocController,
                      prefixIcon: Icon(Icons.search),
                      hintText: "Search a document",
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  CustomFilledButton(
                    width: 120,
                    height: 56,
                    click: () {},
                    child: Text(
                      "Search",
                      style: GoogleFonts.inter(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  // CustomTextField(controller: searchDocController),
                  // SizedBox(
                  //   width: 4,
                  // ),
                  // CustomFilledButton(
                  //   click: () {},
                  //   child: Text("Search"),
                  // ),
                ],
              ),

              // public documents list
            ],
          ),
        ),
      ),
    );
  }
}
