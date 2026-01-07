import 'package:appwidgetflutter/utills/colors_resources.dart';
import 'package:appwidgetflutter/utills/images_sources.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:in_app_review/in_app_review.dart';
void showRatingDialog(context) {
    void _rateAndReviewApp() async {
      final _inAppReview = InAppReview.instance;
      if (await _inAppReview.isAvailable()) {
        _inAppReview.requestReview();
      } else {
        _inAppReview.openStoreListing(
          appStoreId: '<your app store id>',
          microsoftStoreId: '<your microsoft store id>',
        );
      }
    }

    final _dialog = RatingDialog(
      starSize: 25.0,
      initialRating: 1.0,
      title: Text("ادعمنا بتقييمك",
        textAlign: TextAlign.center,
        style: GoogleFonts.lexend(
          color:ColorResources.THEMECOLOR,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      message: Text(
        'ما مدى رضاك عن التطبيق',
        textAlign: TextAlign.center,
        style: GoogleFonts.lexend(fontSize: 15),
      ),
      // your app's logo?
      image: Image.asset(Images.splash_logo),
      submitButtonText: 'يُقدِّم',
      submitButtonTextStyle: GoogleFonts.lexend(
        color: ColorResources.BOTTOM_BAR_SELECTED,
      ),
      commentHint: "",
      onCancelled: () => print('cancelled'),
      onSubmitted: (response) {
        print('rating: ${response.rating}, comment: ${response.comment}');
        if (response.rating < 3.0) {
        } else {
          _rateAndReviewApp();
        }
      },
    );

    showDialog(
      context: context,
      barrierDismissible: true, 
      builder: (context) => _dialog,
    );
  }