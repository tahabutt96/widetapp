import 'package:appwidgetflutter/common/backgorund_image.dart';
import 'package:appwidgetflutter/common/menu_button.dart';
import 'package:appwidgetflutter/common/switch_button_widget.dart';
import 'package:appwidgetflutter/new_firebase/common/drawer_widget.dart';
import 'package:appwidgetflutter/new_firebase/models/category_item.dart';
import 'package:appwidgetflutter/new_firebase/services/json_service.dart';
import 'package:appwidgetflutter/new_firebase/services/favorites_service.dart';
import 'package:appwidgetflutter/new_firebase/models/verse_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_widget/home_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
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
  List<CategoryItem> allCategories = getAllCategories();

  void isGetMethod() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {

    category = sp.getString('Category');
    print("==> Get Cat${category = sp.getString('Category')}");
    ayat = sp.getString('');
    print("==> Get Ayat${ayat = sp.getString('CompletAyat')}");
    });
  }

  Future<void> selectCategory(String categoryName) async {
    try {
      print('📱 Selecting category: $categoryName');

      // Save category to preferences
      SharedPreferences sp = await SharedPreferences.getInstance();
      await sp.setString('Category', categoryName);

      setState(() {
        category = categoryName;
        isShowContainer = false;
      });

      // Load verses from JSON
      print('📱 Loading verses from JSON...');
      final verses = await JsonService.getVersesByCategory(categoryName);
      print('📱 Verses loaded: ${verses.length}');

      if (verses.isNotEmpty) {
        // Get first verse to update widget
        final firstVerse = verses[0];
        await _sendAndUpdate(categoryName, firstVerse.verse);

        // Show ayats dialog
        //await showAyatsDialog(categoryName, verses);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('لا توجد آيات في هذه الفئة'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      print('❌ Error selecting category: $e');

      // Show error message to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('حدث خطأ أثناء تحميل الآيات: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
 
  Future<void> showCategoryDialog() async {
    final selectedCategory = await showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(10),
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                // Header
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: ColorResources.THEMECOLOR,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.of(dialogContext).pop(),
                      ),
                      Text(
                        'بماذا تشعر ؟',
                        style: GoogleFonts.cairo(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 48), // Balance the close button
                    ],
                  ),
                ),
                // Categories List
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    itemCount: allCategories.length,
                    itemBuilder: (context, index) {
                      final cat = allCategories[index];
                      final isSelected = category == cat.name;

                      return InkWell(
                        onTap: () {
                          // Close the category dialog first using the dialog's own context
                          Navigator.of(dialogContext).pop(cat.name);
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          decoration: BoxDecoration(
                            color: isSelected
                              ? ColorResources.THEMECOLOR.withAlpha((0.1 * 255).toInt())
                              : Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: isSelected
                                ? ColorResources.THEMECOLOR
                                : Colors.grey.withAlpha((0.3 * 255).toInt()),
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Checkmark
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isSelected
                                    ? ColorResources.THEMECOLOR
                                    : Colors.transparent,
                                  border: Border.all(
                                    color: isSelected
                                      ? ColorResources.THEMECOLOR
                                      : Colors.grey.withAlpha((0.5 * 255).toInt()),
                                    width: 2,
                                  ),
                                ),
                                child: isSelected
                                  ? Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 16,
                                    )
                                  : null,
                              ),
                              SizedBox(width: 12),
                              // Category Name
                              Expanded(
                                child: Text(
                                  cat.name,
                                  textAlign: TextAlign.right,
                                  style: GoogleFonts.cairo(
                                    fontSize: 18,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                    color: isSelected
                                      ? ColorResources.THEMECOLOR
                                      : ColorResources.BOTTOM_BAR_SELECTED,
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              // Icon with teal background
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: ColorResources.THEMECOLOR.withAlpha((0.15 * 255).toInt()),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  cat.icon ?? Icons.circle,
                                  size: 28,
                                  color: ColorResources.THEMECOLOR,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    // IMPORTANT: Wait for dialog to close COMPLETELY before proceeding
    if (selectedCategory != null && mounted) {
      // Give the dialog plenty of time to close and animations to finish
      await Future.delayed(Duration(milliseconds: 600));

      // Double-check the widget is still mounted
      if (mounted) {
        await selectCategory(selectedCategory);
      }
    }
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
              // Container(
              //   height: 70.0,
              //   child: Center(
              //    child: Image.asset(
              //     Images.splash_logo, 
              //     height: 50.0, 
              //     width: double.infinity
              //   ),
              //  ),
              // ),
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
                            SizedBox(height: 20,),
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
                                    "ما هو شعورك الآن؟",
                                    style: GoogleFonts.lexend(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20,
                                      color: ColorResources.BOTTOM_BAR_SELECTED), /*textDirection: TextDirection.rtl*/
                                  ),
                                ),
                                
                                InkWell(
                                  onTap: showCategoryDialog,
                                  child: Container(
                                    margin: EdgeInsets.symmetric(horizontal: 20.0),
                                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                                    decoration: BoxDecoration(
                                      color: ColorResources.WHITE,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withAlpha((0.3 * 255).toInt()),
                                          blurRadius: 4,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(
                                        color: ColorResources.THEMECOLOR.withAlpha((0.3 * 255).toInt()),
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Icon(
                                          Icons.arrow_drop_down,
                                          color: ColorResources.THEMECOLOR,
                                          size: 28,
                                        ),
                                        Text(
                                          category ?? "الفئة",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.cairo(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: ColorResources.THEMECOLOR,
                                          ),
                                          textDirection: TextDirection.rtl,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
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