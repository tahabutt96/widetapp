import 'package:appwidgetflutter/dashboard/controllers/drawer_controller.dart';
import 'package:appwidgetflutter/dashboard/dashboard_common/custom_button.dart';
import 'package:appwidgetflutter/dashboard/dashboard_common/dashboard_drawer.dart';
import 'package:appwidgetflutter/utills/colors_resources.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_builder/responsive_builder.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{
  final Widget body;
  const CustomAppBar({Key? key, required this.body}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final globalKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: globalKey,
      drawer: SizedBox(width: 200.0, child: DrawerWidget(globalkey: globalKey)),
      body: body,
      appBar: AppBar(
      centerTitle: true,
      title: Text('Dashboard',style: GoogleFonts.lexend(
       ),
      ),
      backgroundColor: ColorResources.THEMECOLOR,
      leading: ScreenTypeLayout(
        mobile: DrawerIcon(
         onTap: ()=> DrawerFunction.onTapMobile(globalKey),
        ),
        desktop: DrawerIcon(
        onTap: ()=> DrawerFunction.onTapWeb(context),
        ),
        tablet: DrawerIcon(
        onTap: ()=> DrawerFunction.onTapWeb(context),
       ),
      ),
      actions: [
      CustomTextButton(
        child: Center(
          child: Text('Log out',
            style: GoogleFonts.lexend(
              color: ColorResources.WHITE,
            ),
          ),
          ),
        onPressed: () {

        }),
      ],
    ),
    );
  }
  
  @override
  Size get preferredSize => const Size(40, 55);
}

class DrawerIcon extends StatelessWidget {
  final VoidCallback onTap;
  const DrawerIcon({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap, 
      icon: const Icon(Icons.menu));
  }
}