import 'package:appwidgetflutter/dashboard/dashboard_common/custom_button.dart';
import 'package:appwidgetflutter/utills/colors_resources.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DoneButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  const DoneButton({Key? key, required this.onPressed, this.text="Upload"}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomTextButton(
      key: key,
      child: Center(
        child: Text(text,
          style: GoogleFonts.lexend(
            fontWeight: FontWeight.w500,
            color: ColorResources.WHITE,
            letterSpacing: 1,
          ),
        ),
      ),
      color: ColorResources.THEMECOLOR,
      borderRadius: 4.0,
      height: 45,
      width: 300,
      onPressed: onPressed!,
    );
  }
}
