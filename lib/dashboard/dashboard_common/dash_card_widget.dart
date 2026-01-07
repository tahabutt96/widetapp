import 'package:appwidgetflutter/utills/colors_resources.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class CardWidget extends StatelessWidget {
  final String? image;
  final String? title;
  final VoidCallback? onTap;
  const CardWidget({Key? key, this.image, this.title, this.onTap,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 300.0,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            Card(
              elevation: 2.0,
              margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
              shape:RoundedRectangleBorder(borderRadius: BorderRadius.only(
                topRight: Radius.circular(5),
                bottomRight: Radius.circular(5),
              )),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Image.asset(image!, height: 50),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(title!,style: GoogleFonts.lexend(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: ColorResources.THEMECOLOR,
                      ),),
                    ],
                  ),
                  const SizedBox(height: 5.0,),
                ],
              ),
            ),
            Container(
              height: 80.0,
              width: 10.0,
              margin: EdgeInsets.only(
                left: 10.0,
              ),
              decoration: BoxDecoration(
                color: ColorResources.THEMECOLOR,
              ),
            ),
          ],
        ),
      ),
    );
  }
}