import 'package:appwidgetflutter/mobile_common/rating_dialog.dart';
import 'package:appwidgetflutter/utills/colors_resources.dart';
import 'package:appwidgetflutter/utills/images_sources.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MobileDrawerWidget extends StatelessWidget {
  const MobileDrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.0,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: ListView(
        padding: EdgeInsets.only(top: 10.0),
        children: [
          // SafeArea(
          //   child: Container(
          //     height: 25.0,
          //     child: Center(
          //       child: Image.asset(
          //       Images.splash_logo, 
          //       height: 50.0, 
          //       width: double.infinity
          //     ),
          //     ),
          //   ),
          // ),
          // SizedBox(
          //   height: 10.0,
          // ),
          // Divider(
          //   height: 2.0,
          //   thickness: 1.0,
          //   color: ColorResources.THEMECOLOR,
          // ),
          SizedBox(
            height: 10.0,
          ),
          CustomListTile(
            title: "ادعمنا بتقييمك", 
            image: Images.share_icon, 
            onPressed: () {
              showRatingDialog(context);
            }
          ),
        ],
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  final String title;
  final String image;
  final VoidCallback onPressed;
  const CustomListTile({Key? key, required this.title, required this.image, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(width: 20.0,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Text(title,
                  style: GoogleFonts.urbanist(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    color: ColorResources.THEMECOLOR
                  ),
                ),
            ],
          ),

          SizedBox(width: 20.0,),
          Image.asset(image,
            width: 25,
            height: 25,
            color: ColorResources.THEMECOLOR,
          ),
          SizedBox(
            width: 10.0,
          ),
        ],
      ),
      onPressed: onPressed,
    );
  }
}