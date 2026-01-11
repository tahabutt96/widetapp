import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:appwidgetflutter/common/widget_instructions_dialog.dart';
import 'package:appwidgetflutter/common/widget_pin_preview_dialog.dart';
import 'package:appwidgetflutter/utills/colors_resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_widget/home_widget.dart';

/// Configuration: Choose widget pin method
/// Set to true: Shows manual instructions (NO native dialog)
/// Set to false: Shows preview + native dialog (RECOMMENDED)
const bool USE_MANUAL_INSTRUCTIONS = false;

class SwitchWidget extends StatefulWidget {
  const SwitchWidget({super.key});

  @override
  State<SwitchWidget> createState() => _SwitchWidgetState();
}

class _SwitchWidgetState extends State<SwitchWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: ColorResources.BOTTOM_BAR,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () async {
                  // Choose between manual instructions or preview + native dialog
                  if (USE_MANUAL_INSTRUCTIONS) {
                    // Option 1: Show manual instructions (no native dialog)
                    await WidgetInstructionsDialog.show(context);
                  } else {
                    // Option 2: Show preview dialog (native dialog will follow)
                    await WidgetPinPreviewDialog.show(context);
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.white,
                  ),
                  child: Container(
                    margin: EdgeInsets.all(2.0),
                    height: 25.0,
                    width: 80.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: ColorResources.BOTTOM_BAR_SELECTED,
                    ),
                    child: Center(
                        child: Text(
                      'تفعيل',
                      style: TextStyle(
                        color: ColorResources.WHITE,
                      ),
                    )),
                  ),
                ),
              ),
              Text(
                "تفعيل الويدجت",
                style: GoogleFonts.lexend(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: ColorResources.BOTTOM_BAR_SELECTED),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CustomSwitch extends StatefulWidget {
  const CustomSwitch({Key? key}) : super(key: key);

  @override
  State<CustomSwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  static const platform = const MethodChannel('samples.flutter.dev/pinWidget');
  bool isSwitchValue = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: AnimatedToggleSwitch<bool>.dual(
        current: isSwitchValue, //SharePrefs.getSwitchValue() ??
        first: false,
        second: true,
        borderWidth: 2.0,
        height: 25,
        minTouchTargetSize: 150.0,
        onChanged: (b) async {
          await platform.invokeMethod('pinWidget');
          setState(() {
            isSwitchValue = !isSwitchValue;
          });
           ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text("تم إضافة الويدجت الى شاشتك الرئيسية بنجاح"),
                                                    backgroundColor: ColorResources.THEMECOLOR,
                                                    duration: Duration(seconds: 5),
                                                  ),
                                                );
          // _sendData(b);
          // if(SharePrefs.getSwitchValue()==null){
          //   await platform.invokeMethod('pinWidget');
          //   SharePrefs.setSwitchValue(true);
          //   setState(() {});
          // }else{
          //   print('hello');
          //   // await platform.invokeMethod('remove');
          //  SharePrefs.setSwitchValue(!SharePrefs.getSwitchValue()!);
          //  setState(() {});
          // }
        },
        textBuilder: (value) =>
            value ? Center(child: Text('')) : Center(child: Text('')),
      ),
    );
  }

  Future _sendData(value) async {
    await HomeWidget.saveWidgetData<bool>('view', value);
    await HomeWidget.updateWidget(
        name: 'AppWidgetProvider', iOSName: 'AppWidgetProvider');
  }
}
