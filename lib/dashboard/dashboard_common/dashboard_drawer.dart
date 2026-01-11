
import 'package:appwidgetflutter/dashboard/provider/drawer_index_provider.dart';
import 'package:appwidgetflutter/utills/colors_resources.dart';
import 'package:appwidgetflutter/utills/images_sources.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DrawerWidget extends StatelessWidget {
  final GlobalKey<ScaffoldState>? globalkey;
  const DrawerWidget({Key? key,this.globalkey}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var indexProvider = Provider.of<DrawerIndexProvider>(context);
    return Container(
      color: ColorResources.dashboardColor,
      child: Column(
        children: [
          // AppBar(
          //   automaticallyImplyLeading: false,
          //   elevation: 0.0,
          //   backgroundColor: ColorResources.dashboardColor,
          //   title: Image.asset(Images.splash_logo),
          // ),
          // const Divider(color: ColorResources.WHITE,),
          Expanded(
            child: ListView(
              controller: ScrollController(),
              children:  [
                CustomTileWidget(
                 title: "Home",isSelected: indexProvider.getSelectedIndex == 0 ? true : false,
                 onPressed: (){
                   indexProvider.setSelectedIndex(0);
                   if(globalkey!=null) {
                     globalkey!.currentState!.closeDrawer();
                   }
                 },
                ),
                CustomTileWidget(
                 title: "Add Category",isSelected: indexProvider.getSelectedIndex == 1 ? true : false,
                 onPressed: (){
                   indexProvider.setSelectedIndex(1);
                   if(globalkey!=null) {
                     globalkey!.currentState!.closeDrawer();
                   }
                 },
                ),
                CustomTileWidget(
                 title: "Add Aya",isSelected: indexProvider.getSelectedIndex == 2 ? true : false,
                 onPressed: (){
                  indexProvider.setSelectedIndex(2);
                   if(globalkey!=null) {
                     globalkey!.currentState!.closeDrawer();
                   }
                 },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomTileWidget extends StatelessWidget {
  final String? title;
  final VoidCallback? onPressed;
  final bool isSelected;
  const CustomTileWidget({Key? key, this.title,this.onPressed,this.isSelected=false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
         color:isSelected? ColorResources.BOTTOM_BAR : Colors.transparent,
         borderRadius: BorderRadius.circular(5.0),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 10.0),
        height: 40,
        child: Center(
          child: Text(title!,style: GoogleFonts.lexend(
            color:ColorResources.THEMECOLOR,
            fontWeight: FontWeight.w500,
            fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}