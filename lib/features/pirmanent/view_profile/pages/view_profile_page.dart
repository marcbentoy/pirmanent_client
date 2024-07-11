import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pirmanent_client/constants.dart';
import 'package:pirmanent_client/main.dart';
import 'package:pirmanent_client/utils.dart';
import 'package:pirmanent_client/widgets/custom_filled_button.dart';
import 'package:pirmanent_client/widgets/snackbars.dart';
import 'package:pocketbase/pocketbase.dart';

class ViewProfilePage extends StatefulWidget {
  const ViewProfilePage({super.key});

  @override
  State<ViewProfilePage> createState() => _ViewProfilePageState();
}

class _ViewProfilePageState extends State<ViewProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(
            child: Center(
              child: SvgPicture.asset("assets/icons/logo_icon.svg"),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // headline
                Text(
                  "My Account",
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: kHeadline,
                  ),
                ),

                SizedBox(height: 24),

                // name
                Text(
                  "Name",
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: kSubheadline,
                  ),
                ),
                Text(
                  userData.name,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: kContent,
                  ),
                ),
                SizedBox(height: 12),

                // email
                Text(
                  "Email",
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: kSubheadline,
                  ),
                ),
                Text(
                  userData.email,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: kContent,
                  ),
                ),
                SizedBox(height: 12),

                // setup 2fa
                // Text(
                //   "2FA Setup",
                //   style: GoogleFonts.inter(
                //     fontSize: 14,
                //     color: kSubheadline,
                //   ),
                // ),
                // userData.fingerprintId == null
                //     ? Row(
                //         children: [
                //           Container(
                //             padding: EdgeInsets.all(8),
                //             decoration: BoxDecoration(
                //               border: Border.all(color: kBorder),
                //               borderRadius: BorderRadius.circular(8),
                //               color: kDarkWhite,
                //             ),
                //             child: Text(
                //               "no fingerprint added",
                //               style: GoogleFonts.inter(
                //                 fontSize: 16,
                //                 fontWeight: FontWeight.bold,
                //                 color: kContent,
                //               ),
                //             ),
                //           ),
                //           SizedBox(
                //             width: 4,
                //           ),
                //           TextButton(
                //             onPressed: () async {
                //               final body = <String, dynamic>{
                //                 "vDeviceId": "PRM0001",
                //                 "user": userId,
                //               };

                //               await pb
                //                   .collection('accountRequests')
                //                   .create(body: body);
                //             },
                //             child: Text(
                //               "enroll fingerprint",
                //               style: GoogleFonts.inter(
                //                 color: kBlue,
                //               ),
                //             ),
                //           ),
                //         ],
                //       )
                //     : Text(
                //         "registered",
                //         style: GoogleFonts.inter(
                //           fontSize: 16,
                //           fontWeight: FontWeight.bold,
                //           color: kContent,
                //         ),
                //       ),

                Divider(
                  color: kBorder,
                ),

                SizedBox(height: 40),

                // logout
                CustomFilledButton(
                  backgroundColor: kRed,
                  click: () async {
                    try {
                      final pbUrl = await getPbUrl();
                      final pb = PocketBase(pbUrl);

                      pb.authStore.clear();
                      if (!pb.authStore.isValid) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(logoutSuccessSnackbar);
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/login');
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(logoutErrorSnackbar);
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(logoutErrorSnackbar);
                    }
                  },
                  child: Text(
                    "Log out",
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: kWhite,
                    ),
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
