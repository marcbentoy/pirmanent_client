import 'package:flutter/material.dart';
import 'package:pirmanent_client/constants.dart';

class CustomFilledButton extends StatelessWidget {
  final Widget child;
  final void Function() click;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? borderColor;

  const CustomFilledButton({
    super.key,
    required this.click,
    required this.child,
    this.width,
    this.height,
    this.backgroundColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: ButtonStyle(
        minimumSize: MaterialStatePropertyAll(Size(width ?? 272, height ?? 48)),
        backgroundColor: MaterialStatePropertyAll(backgroundColor ?? kBlue),
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(
            side: BorderSide(color: borderColor ?? Colors.transparent),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        padding: MaterialStatePropertyAll(
          EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        ),
      ),
      onPressed: click,
      child: child,
    );
  }
}
