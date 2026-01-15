import 'package:appwidgetflutter/common/back_button.dart';
import 'package:appwidgetflutter/common/backgorund_image.dart';
import 'package:appwidgetflutter/new_firebase/on_boarding_screen.dart';
import 'package:appwidgetflutter/utills/all_text.dart';
import 'package:appwidgetflutter/utills/colors_resources.dart';
import 'package:appwidgetflutter/utills/images_sources.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:google_fonts/google_fonts.dart';
class ShareScreen extends StatelessWidget {
  final bool? isShowBack;
  ShareScreen({Key? key, this.isShowBack=false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundImage(
        child: Column(
          children: [
            // Container(
            //   margin: EdgeInsets.only(top: 20.0),
            //     height: 70.0,
            //     child: Center(
            //      child: Image.asset(
            //       Images.splash_logo, 
            //       height: 50.0, 
            //       width: double.infinity
            //     ),
            //    ),
            //   ),
              isShowBack! ?
              BackButtonWidget():Container(),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                 "كلنا بنمر بلحظات محتاجين فيها طمأنينة والقرآن دايمًا بيكون أقرب طريق للراحة، لو التطبيق لمس قلبك وساعدك شاركه مع من تحب"

    ,                  textAlign: TextAlign.center,
                      style: GoogleFonts.urbanist(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        color: ColorResources.THEMECOLOR,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 35.0),
                    child: SliderButton(
                      text: "شارك التطبيق", 
                      textColor: Colors.white, 
                      buttonColor: ColorResources.THEMECOLOR, 
                      onPressed: () async{
                        await Share.share(
                            AllText.appLink,
                            subject: 'Quran App');
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}