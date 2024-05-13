import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pirmanent_client/constants.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool? obscure;
  final Widget? prefixIcon;
  final String? hintText;

  const CustomTextField({
    super.key,
    this.obscure,
    required this.controller,
    this.prefixIcon,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: kBlue,
      obscureText: obscure ?? false,
      controller: controller,
      style: GoogleFonts.inter(),
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kBorder),
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kBorder),
          borderRadius: BorderRadius.circular(8),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: kBorder),
          borderRadius: BorderRadius.circular(8),
        ),
        fillColor: kDarkWhite,
        filled: true,
      ),
    );
  }
}
