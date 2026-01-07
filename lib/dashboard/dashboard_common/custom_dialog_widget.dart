// ignore_for_file: constant_identifier_names

import 'package:appwidgetflutter/dashboard/dashboard_common/custom_button.dart';
import 'package:appwidgetflutter/utills/colors_resources.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum CustomDialogType { ALERT, CONFIRM, ABOUT, SIMPLE }

class CustomDialog extends StatelessWidget {
  final String title, body;
  final String? buttonText, falseButtonText, trueButtonText;
  final CustomDialogType _type;
  final VoidCallback? falseButtonPressed, trueButtonPressed;

  const CustomDialog._({
    this.buttonText,
    this.falseButtonText,
    this.trueButtonText,
    this.falseButtonPressed,
    this.trueButtonPressed,
    required this.title,
    required this.body,
    required CustomDialogType type,
  }) : _type = type;

  const factory CustomDialog.alert({
    required String title,
    required String body,
    required String buttonText,
    VoidCallback? onButtonPressed,
  }) = _CustomDialogWithAlert;

  const factory CustomDialog.confirm({
    required String title,
    required String body,
    required String falseButtonText,
    required String trueButtonText,
    VoidCallback? falseButtonPressed,
    VoidCallback? trueButtonPressed,
  }) = _CustomDialogWithConfirm;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 19),
      titlePadding: const EdgeInsets.fromLTRB(19, 14, 19, 0),
      contentPadding: const EdgeInsets.fromLTRB(19, 9, 19, 9),
      actionsPadding: const EdgeInsets.fromLTRB(0, 0, 8, 8),
      backgroundColor: ColorResources.WHITE,
      title: Text(title,style: GoogleFonts.lexend(),),
      content: Text(
        body,
        style: GoogleFonts.lexend(),
      ),
      actions: <Widget>[
        if (_type == CustomDialogType.ALERT)
          CustomTextButton(
            child: Center(
              child: Text(
                buttonText!,
                style: const TextStyle(color: Colors.black),
              ),
            ),
            height: 40,
            width: 60,
            onPressed: () {
              trueButtonPressed?.call();
              Navigator.of(context).pop();
            },
          )
        else if (_type == CustomDialogType.CONFIRM) ...[
          CustomTextButton(
            child: Center(
              child: Text(
                trueButtonText!,
                style: const TextStyle(color: ColorResources.THEMECOLOR),
              ),
            ),
            height: 40,
            width: 60,
            onPressed: () {
              trueButtonPressed?.call();
              Navigator.of(context).pop();
            },
          ),
          CustomTextButton(
            child: Center(
              child: Text(
                falseButtonText!,
                style: const TextStyle(color: Colors.black),
              ),
            ),
            height: 40,
            width: 60,
            onPressed: () {
              falseButtonPressed?.call();
              Navigator.of(context).pop();
            },
          ),
        ]
      ],
    );
  }
}

class _CustomDialogWithAlert extends CustomDialog {
  const _CustomDialogWithAlert({
    required String title,
    required String body,
    required String buttonText,
    VoidCallback? onButtonPressed,
  }) : super._(
          title: title,
          body: body,
          buttonText: buttonText,
          trueButtonPressed: onButtonPressed,
          type: CustomDialogType.ALERT,
        );
}

class _CustomDialogWithConfirm extends CustomDialog {
  const _CustomDialogWithConfirm({
    required String title,
    required String body,
    required String falseButtonText,
    required String trueButtonText,
    VoidCallback? falseButtonPressed,
    VoidCallback? trueButtonPressed,
  }) : super._(
          title: title,
          body: body,
          falseButtonText: falseButtonText,
          trueButtonText: trueButtonText,
          falseButtonPressed: falseButtonPressed,
          trueButtonPressed: trueButtonPressed,
          type: CustomDialogType.CONFIRM,
        );
}
