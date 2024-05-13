import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pirmanent_client/constants.dart';
import 'package:pirmanent_client/features/auth/login_acc/pages/login_page.dart';
import 'package:pirmanent_client/widgets/custom_text_field.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController repeatPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // illustration
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: kBlack,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Image.asset("assets/branding/logo.png"),
              ),
            ),
          ),

          // form
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // heading
                  Text(
                    "Create an Account",
                    style: GoogleFonts.inter(
                      color: kHeadline,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      // wordSpacing: -4,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  // Text(
                  //   "Start to sign important documents",
                  //   style: GoogleFonts.inter(
                  //     color: kSubheadline,
                  //     fontSize: 14,
                  //   ),
                  // ),

                  // spacer
                  SizedBox(
                    height: 64,
                  ),

                  // name field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Name",
                        style: GoogleFonts.inter(
                          color: kContent,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      CustomTextField(
                        controller: nameController,
                      ),
                    ],
                  ),

                  // spacer
                  SizedBox(
                    height: 24,
                  ),

                  // email field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Email",
                        style: GoogleFonts.inter(
                          color: kContent,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      CustomTextField(
                        controller: emailController,
                      ),
                    ],
                  ),

                  // spacer
                  SizedBox(
                    height: 24,
                  ),

                  // password field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Password",
                        style: GoogleFonts.inter(
                          color: kContent,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      CustomTextField(
                        controller: passwordController,
                        obscure: true,
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 12,
                  ),

                  // repeat password field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Repeat password",
                        style: GoogleFonts.inter(
                          color: kContent,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      CustomTextField(
                        controller: repeatPassController,
                        obscure: true,
                      ),
                    ],
                  ),

                  // spacer
                  SizedBox(
                    height: 24,
                  ),

                  // login button
                  FilledButton(
                    style: ButtonStyle(
                      minimumSize: MaterialStatePropertyAll(Size(272, 48)),
                      backgroundColor: MaterialStatePropertyAll(kBlue),
                      shape: MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      padding: MaterialStatePropertyAll(
                        EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      ),
                    ),
                    onPressed: () {
                      // setState(() {});
                      debugPrint(emailController.text);
                      debugPrint(passwordController.text);
                    },
                    child: Text(
                      "Create Account",
                      style: GoogleFonts.inter(
                        color: kWhite,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // redirect to sing up page button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: GoogleFonts.inter(),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return LoginPage();
                              },
                            ),
                          );
                        },
                        child: Text(
                          "Login",
                          style: GoogleFonts.inter(
                            color: kBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
