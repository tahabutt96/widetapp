import 'package:appwidgetflutter/common/backgorund_image.dart';
import 'package:appwidgetflutter/common/menu_button.dart';
import 'package:appwidgetflutter/common/switch_button_widget.dart';
import 'package:appwidgetflutter/new_firebase/common/drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_widget/home_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utills/colors_resources.dart';
import '../utills/images_sources.dart';

class CategoriesGallery extends StatefulWidget {
  final String? name;

  CategoriesGallery(
      {Key? key,
      this.name})
      : super(key: key);

  @override
  _CategoriesGalleryState createState() => _CategoriesGalleryState();
}

class _CategoriesGalleryState extends State<CategoriesGallery> {
  int value = 0;
  bool positive = false;
  bool isShowContainer = false;
  String? category;
  String? ayat;
  final key = GlobalKey<ScaffoldState>();
  void isGetMethod() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      
    category = sp.getString('Category');
    print("==> Get Cat${category = sp.getString('Category')}");
    ayat = sp.getString('');
    print("==> Get Ayat${ayat = sp.getString('CompletAyat')}");
    });
  }
  bool? selected;
  @override
  void initState() {
    isGetMethod();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      drawer: MobileDrawerWidget(),
      body: SafeArea(
        child: BackgroundImage(
          child: Builder(
            builder: (BuildContext context) {
              return Column(
                children: [
              Container(
                height: 70.0,
                child: Center(
                 child: Image.asset(
                  Images.splash_logo, 
                  height: 50.0, 
                  width: double.infinity
                ),
               ),
              ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 12.0),
                            child: MenuButton(
                              onTap: () {
                                key.currentState!.openDrawer();
                              },
                            )),
                          Container(
                            alignment: Alignment.center,
                            height: 250,
                            child: Image.asset(Images.app_screen),
                          ),
                          /// Box blue color
                          SingleChildScrollView(
                            padding: EdgeInsets.symmetric(horizontal: 12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                    padding: EdgeInsets.only(top: 40, bottom: 10),
                                    child: SwitchWidget()),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                                  child: Text(
                                    "فئة القطعة",
                                    style: GoogleFonts.lexend(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20,
                                      color: ColorResources.BOTTOM_BAR_SELECTED), /*textDirection: TextDirection.rtl*/
                                  ),
                                ),
                                
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                                  decoration: BoxDecoration(
                                    color: ColorResources.WHITE,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 1,
                                      ),
                                    ],
                                    borderRadius: BorderRadius.only(
                                      topLeft: isShowContainer?Radius.circular(30):Radius.circular(30),
                                      topRight: isShowContainer?Radius.circular(30):Radius.circular(30),
                                      bottomLeft: isShowContainer?Radius.circular(0):Radius.circular(30),
                                      bottomRight: isShowContainer?Radius.circular(0):Radius.circular(30),
                                    ),
                                   ),
                                    child: Column(
                                      children: [
                                      Card(
                                          elevation:isShowContainer?1: 0,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                    setState(() {
                                                      isShowContainer=!isShowContainer;
                                                    });
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Image.asset(
                                                    Images.share,
                                                    width: 20,
                                                    height: 17,
                                                  ),
                                                ),
                                              ),
                                              // ListTile(
                                              //   dense: true,
                                              //   shape: RoundedRectangleBorder(
                                              //       borderRadius:
                                              //           BorderRadius.circular(30)),
                                              //   visualDensity: VisualDensity(
                                              //       horizontal: 0, vertical: -1),
                                              //   tileColor: ColorResources.WHITE,
                                              //   leading: InkWell(
                                              //     onTap: (){
                                              //       setState(() {
                                              //         isShowContainer=!isShowContainer;
                                              //       });
                                              //     },
                                              //     child: Padding(
                                              //       padding: const EdgeInsets.all(8.0),
                                              //       child: Image.asset(
                                              //         Images.share,
                                              //         width: 20,
                                              //         height: 17,
                                              //       ),
                                              //     ),
                                              //   ),
                                              // ),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                child: Text(
                                                  category??"الفئة",
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: GoogleFonts.lexend(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w500,
                                                    color: ColorResources.BOTTOM_BAR_SELECTED),
                                                  textDirection: TextDirection.rtl),
                                              ),
                                            ],
                                          )),
                                          isShowContainer?
                                      Container(
                                          padding:
                                              EdgeInsets.symmetric(horizontal: 12),
                                          child: Text(
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: ColorResources
                                                    .BOTTOM_BAR_SELECTED,
                                                fontWeight: FontWeight.bold),
                                            "يمكنك اختيار التصنيف الذي تريده من خلال الذهاب الى صفحة التصنيفات ثم الضغط على التصنيف والضغط على زر ",
                                            textAlign: TextAlign.center,
                                          )):Container(),
                                    ])),
                                SizedBox(height: 10),
                                // Text("موضوع القطعة",
                                //     style: GoogleFonts.lexend(
                                //       fontWeight: FontWeight.w600,
                                //       fontSize: 20,
                                //       color: ColorResources.BOTTOM_BAR_SELECTED,
                                //     ),
                                //     textDirection: TextDirection.rtl),
                                // Padding(
                                //   padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                //   child: Card(
                                //       elevation: 1,
                                //       shape: RoundedRectangleBorder(
                                //           borderRadius: BorderRadius.circular(30)),
                                //       child: ListTile(
                                //         dense: true,
                                //         shape: RoundedRectangleBorder(
                                //             borderRadius: BorderRadius.circular(30)),
                                //         visualDensity:
                                //             VisualDensity(horizontal: 0, vertical: -1),
                                //         tileColor: ColorResources.WHITE,
                                //         leading: Image.asset(Images.share,
                                //           width: 20,
                                //           height: 17,
                                //         ),
                                //         trailing: Text("إشباع",
                                //             maxLines: 1,
                                //             overflow: TextOverflow.ellipsis,
                                //             style: TextStyle(
                                //                 fontSize: 18,
                                //                 color:
                                //                     ColorResources.BOTTOM_BAR_SELECTED),
                                //             textDirection: TextDirection.rtl),
                                //       )),
                                // ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _sendAndUpdate(var name, var ayatDescription) async {
    await _sendData(name, ayatDescription);
    await _updateWidget();
  }

  _sendData(var name, var ayatdescription) async {
    try {
      return Future.wait([
        HomeWidget.saveWidgetData<String>('title', name),
        HomeWidget.saveWidgetData<String>('message', ayatdescription)
      ]);
    } on PlatformException catch (exception) {
      debugPrint('Error Sending Data. $exception');
    }
  }

  _updateWidget() async {
    try {
      return HomeWidget.updateWidget(
          name: 'AppWidgetProvider', iOSName: 'HomeWidgetExample');
    } on PlatformException catch (exception) {
      debugPrint('Error Updating Widget. $exception');
    }
  }
}


// nChanged: (b) => setState(() {
//                                       print('value changing through switch');
//                                       positive = b;
//                                       if (positive) {
//                                         _sendAndUpdate(
//                                           category.toString(),
//                                           ayat.toString(),
//                                           /*widget
//                                                 .wallpaperList![
//                                                     widget.initialPage!]
//                                                 .name,*/
//                                           /* widget
//                                                 .wallpaperList![
//                                                     widget.initialPage!]
//                                                 .complete_ayat*/
//                                         );
//                                       } else {
//                                         _sendAndUpdate("", "");
//                                       }
//                                     }),