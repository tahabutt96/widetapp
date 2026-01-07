import 'package:appwidgetflutter/utills/colors_resources.dart';
import 'package:appwidgetflutter/utills/size_config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryCardWidget extends StatelessWidget {
  final String image;
  final String title;
  final Color? selectedColor;
  final bool? isLocalImage;
  const CategoryCardWidget({super.key, required this.image, required this.title, this.selectedColor=ColorResources.WHITE, this.isLocalImage=false});
  @override
  Widget build(BuildContext context) {
    return Container(
     height: 130,
     width: SizeConfig.widthForCatWidet(context),
     child: Card(
      margin: EdgeInsets.zero,
      elevation: 5,
      color: selectedColor,
      shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20)),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50.0,
              height: 50.0,
              margin: EdgeInsets.only(bottom: 10),
              child: isLocalImage! ?
               Image.asset(image):
               CachedNetworkImage(
                imageUrl: image,
                placeholder: (context, url) {
                  return CircularProgressIndicator(
                    strokeWidth: 1.0,
                    valueColor: AlwaysStoppedAnimation(ColorResources.THEMECOLOR),
                  );
                },
                errorWidget: (context, url, error) {
                  return Text('error');
                },
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
              child: Text(title,
              textAlign: TextAlign.center,
              softWrap: true,
              style: GoogleFonts.lexend(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: ColorResources.BOTTOM_BAR_SELECTED,
          ),
         ),
        ),
       ],
      ),
     ),
    ),
   );
  }
}