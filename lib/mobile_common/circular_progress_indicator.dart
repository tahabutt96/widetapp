import 'package:appwidgetflutter/utills/colors_resources.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomCircularProgressIndicator extends StatelessWidget {
  const CustomCircularProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      color: ColorResources.THEMECOLOR,
    );
  }
}

class EmptyData extends StatelessWidget {
  const EmptyData({super.key});

  @override
  Widget build(BuildContext context) {
    return Text("Loading...",
      style: GoogleFonts.lexend(
        color:ColorResources.THEMECOLOR,
      ),
    );
  }
}

class ErrorText extends StatelessWidget {
  const ErrorText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text('Error in data',
      style: GoogleFonts.lexend(
        color: ColorResources.redColor,
      ),
    );
  }
}