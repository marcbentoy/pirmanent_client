import 'package:cryptography/cryptography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pirmanent_client/constants.dart';
import 'package:pirmanent_client/core/crypto_utils.dart';
import 'package:pirmanent_client/features/auth/login_acc/pages/login_page.dart';
import 'package:pirmanent_client/utils.dart';
import 'package:pirmanent_client/widgets/custom_filled_button.dart';
import 'package:pirmanent_client/widgets/custom_text_field.dart';
import 'package:pirmanent_client/widgets/snackbars.dart';
import 'package:pocketbase/pocketbase.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController usernameController = TextEditingController();
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
                  const SizedBox(
                    height: 8,
                  ),

                  // spacer
                  const SizedBox(
                    height: 64,
                  ),

                  // username field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Username",
                        style: GoogleFonts.inter(
                          color: kContent,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      CustomTextField(
                        controller: usernameController,
                      ),
                    ],
                  ),

                  // spacer
                  const SizedBox(
                    height: 24,
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
                      const SizedBox(
                        height: 4,
                      ),
                      CustomTextField(
                        controller: nameController,
                      ),
                    ],
                  ),

                  // spacer
                  const SizedBox(
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

                  const SizedBox(
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
                      const SizedBox(
                        height: 4,
                      ),
                      CustomTextField(
                        controller: repeatPassController,
                        obscure: true,
                      ),
                    ],
                  ),

                  // spacer
                  const SizedBox(
                    height: 24,
                  ),

                  // sign up button
                  CustomFilledButton(
                    click: () async {
                      try {
                        // generate public-private key
                        final algorithm = Ed25519();
                        final keyPair = await algorithm.newKeyPair();

                        final convertedPrivateKey = intsToHexString(
                            await keyPair.extractPrivateKeyBytes());
                        debugPrint("private key: $convertedPrivateKey");

                        final extractedPubKey =
                            await keyPair.extractPublicKey();
                        debugPrint(
                            "public key: ${intsToHexString(extractedPubKey.bytes)}");

                        // store private key securely
                        final body = <String, dynamic>{
                          "username": usernameController.text,
                          "email": emailController.text,
                          "emailVisibility": true,
                          "password": passwordController.text,
                          "passwordConfirm": repeatPassController.text,
                          "name": nameController.text,
                          "publicKey": intsToHexString(extractedPubKey.bytes),
                        };

                        const sstorage = FlutterSecureStorage();
                        sstorage.write(
                            key: emailController.text,
                            value: convertedPrivateKey);

                        final pbUrl = await getPbUrl();
                        final pb = PocketBase(pbUrl);

                        final record =
                            await pb.collection('users').create(body: body);

                        debugPrint(record.created);

                        if (record.created.isNotEmpty) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(signupSuccessSnackbar);
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/login');
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(signupErrorSnackbar);
                        }
                      } catch (e) {
                        debugPrint(e.toString());
                        ScaffoldMessenger.of(context)
                            .showSnackBar(signupErrorSnackbar);
                      }
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
                                return const LoginPage();
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
