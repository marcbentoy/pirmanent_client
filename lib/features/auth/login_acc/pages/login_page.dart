import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pirmanent_client/constants.dart';
import 'package:pirmanent_client/features/auth/signup_acc/pages/signup_page.dart';
import 'package:pirmanent_client/main.dart';
import 'package:pirmanent_client/models/user_model.dart';

import 'package:pirmanent_client/widgets/custom_text_field.dart';
import 'package:pirmanent_client/widgets/snackbars.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../widgets/custom_filled_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final pb = PocketBase('http://192.168.1.48:8090');

  @override
  void initState() {
    super.initState();
    if (pb.authStore.isValid) {
      Navigator.pop(context);
      Navigator.pushNamed(context, '/app');
    }
  }

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
                    "Login your Account",
                    style: GoogleFonts.inter(
                      color: kHeadline,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      // wordSpacing: -4,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),

                  // spacer
                  const SizedBox(
                    height: 64,
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
                      const SizedBox(
                        height: 4,
                      ),
                      CustomTextField(
                        controller: emailController,
                      ),
                    ],
                  ),

                  // spacer
                  const SizedBox(
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
                      const SizedBox(
                        height: 4,
                      ),
                      CustomTextField(
                        controller: passwordController,
                        obscure: true,
                      ),
                    ],
                  ),

                  // spacer
                  const SizedBox(
                    height: 24,
                  ),

                  // login button
                  CustomFilledButton(
                    click: () async {
                      try {
                        final authData = await pb
                            .collection('users')
                            .authWithPassword(
                                emailController.text, passwordController.text);

                        setState(() {
                          authToken = authData.token;
                        });

                        // pb.authStore.save();
                        var loggedInUserData =
                            jsonDecode(pb.authStore.model.toString());

                        if (pb.authStore.isValid) {
                          final SharedPreferences prefs =
                              await SharedPreferences.getInstance();

                          await prefs.setString('pb_aut', authData.token);

                          // update userdata
                          setState(() {
                            userData = User(
                              email: pb.authStore.model
                                  .getDataValue<String>("email"),
                              name: pb.authStore.model
                                  .getDataValue<String>("name"),
                              publicKey: pb.authStore.model
                                  .getDataValue<String>("publicKey"),
                            );

                            userId = loggedInUserData['id'];
                          });
                          // print("user id: $userId");

                          // show snackbar
                          ScaffoldMessenger.of(context)
                              .showSnackBar(loginSuccessSnackbar);
                          Navigator.pushNamed(context, '/app');
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(loginErrorSnackbar);
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(loginErrorSnackbar);
                      }
                    },
                    child: Text(
                      "Login",
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
                        "Don't have an account?",
                        style: GoogleFonts.inter(),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return const SignupPage();
                              },
                            ),
                          );
                        },
                        child: Text(
                          "Sign up",
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
