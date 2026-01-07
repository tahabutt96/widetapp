import 'package:appwidgetflutter/utills/colors_resources.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddCategoryToWidgetButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? color;
  final String? text;
  const AddCategoryToWidgetButton({super.key, this.onPressed, this.color, this.text});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Container(
        height: 40.0,
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 15.0),
        decoration: BoxDecoration(
          color:color?? ColorResources.THEMECOLOR,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          Text(text??"أضف هذه الفئة إلى القطعة",
            textAlign: TextAlign.end,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.lexend(
              fontSize: 17.0,
              fontWeight: FontWeight.bold,
              color: ColorResources.WHITE,
            ),
           ),
           Container(
            margin: EdgeInsets.only(left: 10.0),
            width: 30,
            decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: ColorResources.WHITE,width: 2.0)),
            child: Icon(Icons.add, color: ColorResources.WHITE,size: 20,))
          ],
        ),
      ),
    );
  }
}