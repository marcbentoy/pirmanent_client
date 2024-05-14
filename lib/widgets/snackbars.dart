import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pirmanent_client/constants.dart';

final loginSuccessSnackbar = SnackBar(
  backgroundColor: kBlue,
  duration: Duration(milliseconds: 1500),
  content: Text(
    "Logged in!",
    style: GoogleFonts.inter(),
  ),
);

final loginErrorSnackbar = SnackBar(
  duration: Duration(milliseconds: 1500),
  backgroundColor: kRed,
  content: Text(
    "Invalid credentials!",
    style: GoogleFonts.inter(),
  ),
);

final signupSuccessSnackbar = SnackBar(
  backgroundColor: kBlue,
  duration: Duration(milliseconds: 1500),
  content: Text(
    "Account created!",
    style: GoogleFonts.inter(),
  ),
);

final signupErrorSnackbar = SnackBar(
  duration: Duration(milliseconds: 1500),
  backgroundColor: kRed,
  content: Text(
    "Invalid credentials!",
    style: GoogleFonts.inter(),
  ),
);

final uploadSuccessSnackbar = SnackBar(
  backgroundColor: kBlue,
  duration: Duration(milliseconds: 1500),
  content: Text(
    "Document uploaded!",
    style: GoogleFonts.inter(),
  ),
);

final uploadErrorSnackbar = SnackBar(
  duration: Duration(milliseconds: 1500),
  backgroundColor: kRed,
  content: Text(
    "Invalid document credentials!",
    style: GoogleFonts.inter(),
  ),
);

final logoutSuccessSnackbar = SnackBar(
  duration: Duration(milliseconds: 1500),
  backgroundColor: kBlue,
  content: Text(
    "Logged out!",
    style: GoogleFonts.inter(),
  ),
);

final logoutErrorSnackbar = SnackBar(
  duration: Duration(milliseconds: 500),
  backgroundColor: kRed,
  content: Text(
    "Error logging out!",
    style: GoogleFonts.inter(),
  ),
);
