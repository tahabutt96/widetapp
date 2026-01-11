import 'package:appwidgetflutter/common/backgorund_image.dart';
import 'package:appwidgetflutter/common/card_widget.dart';
import 'package:appwidgetflutter/common/menu_button.dart';
import 'package:appwidgetflutter/new_firebase/common/drawer_widget.dart';
import 'package:appwidgetflutter/new_firebase/fav.dart';
import 'package:appwidgetflutter/new_firebase/services/json_service.dart';
import 'package:appwidgetflutter/new_firebase/services/favorites_service.dart';
import 'package:appwidgetflutter/new_firebase/models/verse_model.dart';
import 'package:appwidgetflutter/new_firebase/models/category_item.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:home_widget/home_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utills/colors_resources.dart';
import '../utills/images_sources.dart';

class Home extends StatefulWidget {
  final int? index;

  Home({Key? key, this.index}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final categories = List<String>.empty(growable: true);
  final categoryImages = List<String>.empty(growable: true);
  final key = GlobalKey<ScaffoldState>();
  List<CategoryItem> allCategories = getAllCategories();
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    _loadSelectedCategory();
  }

  Future<void> _loadSelectedCategory() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      selectedCategory = sp.getString('Category');
    });
  }

  Future<void> _sendAndUpdate(String categoryName, String ayatDescription) async {
    await _sendData(categoryName, ayatDescription);
    await _updateWidget();
  }

  Future<void> _sendData(String name, String ayatdescription) async {
    try {
      await Future.wait([
        HomeWidget.saveWidgetData<String>('title', name),
        HomeWidget.saveWidgetData<String>('message', ayatdescription)
      ]);
    } catch (exception) {
      debugPrint('Error Sending Data. $exception');
    }
  }

  Future<void> _updateWidget() async {
    try {
      await HomeWidget.updateWidget(
          name: 'AppWidgetProvider', iOSName: 'HomeWidgetExample');
    } catch (exception) {
      debugPrint('Error Updating Widget. $exception');
    }
  }

  Future<void> showAyatsDialog(String categoryName, List<VerseModel> verses) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.all(10),
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.85,
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
                          Expanded(
                            child: Text(
                              categoryName,
                              style: GoogleFonts.cairo(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 48),
                        ],
                      ),
                    ),
                    // Verses count
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: ColorResources.THEMECOLOR.withAlpha((0.1 * 255).toInt()),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.book_outlined, color: ColorResources.THEMECOLOR, size: 18),
                          SizedBox(width: 8),
                          Text(
                            'عدد الآيات: ${verses.length}',
                            style: GoogleFonts.cairo(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: ColorResources.THEMECOLOR,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Verses List
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        itemCount: verses.length,
                        itemBuilder: (context, index) {
                          final verse = verses[index];
                          return FutureBuilder<bool>(
                            future: FavoritesService.isFavorite(verse.verse),
                            builder: (context, snapshot) {
                              final isFavorite = snapshot.data ?? false;
                              return Container(
                                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: Colors.grey.withAlpha((0.2 * 255).toInt())),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withAlpha((0.1 * 255).toInt()),
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    // Verse text
                                    InkWell(
                                      onTap: () async {
                                        //await _sendAndUpdate(categoryName, verse.verse);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('تم تحديث الويدجت'),
                                            backgroundColor: ColorResources.THEMECOLOR,
                                            duration: Duration(seconds: 1),
                                          ),
                                        );
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.all(16),
                                        child: Text(
                                          verse.verse,
                                          textAlign: TextAlign.center,
                                          textDirection: TextDirection.rtl,
                                          style: GoogleFonts.cairo(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            color: ColorResources.BOTTOM_BAR_SELECTED,
                                            height: 1.8,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Surah name
                                    if (verse.surah.isNotEmpty)
                                      Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                        decoration: BoxDecoration(
                                          color: ColorResources.THEMECOLOR.withAlpha((0.05 * 255).toInt()),
                                        ),
                                        child: Text(
                                          verse.surah,
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.cairo(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: ColorResources.THEMECOLOR,
                                          ),
                                        ),
                                      ),
                                    // Action buttons
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.withAlpha((0.05 * 255).toInt()),
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(15),
                                          bottomRight: Radius.circular(15),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          // Share button
                                          Expanded(
                                            child: InkWell(
                                              onTap: () async {
                                                final shareText = '${verse.verse}\n\n${verse.surah}';
                                                await Share.share(shareText, subject: 'آية قرآنية');
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(vertical: 10),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.share, color: ColorResources.THEMECOLOR, size: 20),
                                                    SizedBox(width: 6),
                                                    Text('مشاركة', style: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.w600, color: ColorResources.THEMECOLOR)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(width: 1, height: 30, color: Colors.grey.withAlpha((0.3 * 255).toInt())),
                                          // Favorite button
                                          Expanded(
                                            child: InkWell(
                                              onTap: () async {
                                                final newState = await FavoritesService.toggleFavorite(verse.verse);
                                                setDialogState(() {});
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text(newState ? 'تمت الإضافة للمفضلة' : 'تمت الإزالة من المفضلة'),
                                                    backgroundColor: ColorResources.THEMECOLOR,
                                                    duration: Duration(seconds: 1),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(vertical: 10),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: isFavorite ? Colors.red : ColorResources.THEMECOLOR, size: 20),
                                                    SizedBox(width: 6),
                                                    Text('المفضلة', style: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.w600, color: ColorResources.THEMECOLOR)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      drawer: MobileDrawerWidget(),
      body: BackgroundImage(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal:12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, 
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
                MenuButton(
                  onTap: () {
                    key.currentState!.openDrawer();
                  },
                ),
                  Expanded(
                    child: ListView(
                    padding: EdgeInsets.zero,
                    physics: BouncingScrollPhysics(),
                    children: [
                      Container(
                        alignment: Alignment.topRight,
                        child: Text(
                          "الدعم النفسي بالقران",
                          textDirection: TextDirection.rtl,
                          style: GoogleFonts.lexend(
                            fontWeight: FontWeight.w600,
                            fontSize: 25,
                            color: ColorResources.THEMECOLOR,
                        ),
                      ),
                      ),
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: Wrap(
                          runSpacing: 10.0,
                          spacing: 10.0,
                          children: allCategories.map((cat) => InkResponse(
                            onTap: () async {
                              // Load verses from JSON
                              final verses = await JsonService.getVersesByCategory(cat.name);

                              if (verses.isNotEmpty) {
                                // Save selected category
                                SharedPreferences sp = await SharedPreferences.getInstance();
                                await sp.setString('Category', cat.name);

                                setState(() {
                                  selectedCategory = cat.name;
                                });

                                // Update widget with first verse
                                final firstVerse = verses[0];
                                //await _sendAndUpdate(cat.name, firstVerse.verse);

                                // Show ayats dialog
                                await showAyatsDialog(cat.name, verses);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('لا توجد آيات في هذه الفئة'),
                                    backgroundColor: Colors.orange,
                                  ),
                                );
                              }
                            },
                            child: Container(
                              width: (MediaQuery.of(context).size.width - 44) / 2,
                              height: 120,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: selectedCategory == cat.name
                                      ? ColorResources.THEMECOLOR
                                      : Colors.grey.withAlpha((0.2 * 255).toInt()),
                                  width: selectedCategory == cat.name ? 2 : 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withAlpha((0.15 * 255).toInt()),
                                    blurRadius: 8,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    cat.icon ?? Icons.circle,
                                    size: 40,
                                    color: ColorResources.THEMECOLOR,
                                  ),
                                  SizedBox(height: 10),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8),
                                    child: Text(
                                      cat.name,
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.cairo(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: ColorResources.BOTTOM_BAR_SELECTED,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )).toList(),
                        ),
                      ),
                      
                      Container(
                          alignment: Alignment.topRight,
                          padding: EdgeInsets.only(top: 20, bottom: 10),
                          child: Text("ايات استوقفتني",
                          textDirection: TextDirection.rtl,
                          style: GoogleFonts.lexend(
                                fontWeight: FontWeight.w600,
                                fontSize: 25,
                                color: ColorResources.BOTTOM_BAR_SELECTED
                          ),
                          ),
                        ),
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) {
                                  return Favorite(
                                  );
                                }));
                              },
                              child: CategoryCardWidget(
                                image: Images.grid_bottom, 
                                title: 'المفضلة',
                                isLocalImage: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
            ),
          ),
        ),
      ),
    );
  }
}

showSureDialog(context,{VoidCallback? onPressed}){
  return showDialog(
    context: context, 
    builder: (context) {
      return Dialog(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("تطبيق معدل",
                  style: GoogleFonts.lexend(
                    color: ColorResources.BOTTOM_BAR_SELECTED,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text("هل تريد تقييم هذا التطبيق",
                style: GoogleFonts.lexend(
                  fontSize: 15.0,
                ),
              ),
              TextButton(
                onPressed: onPressed,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 200,
                    height: 30,
                    decoration: BoxDecoration(
                      color: ColorResources.BOTTOM_BAR_SELECTED,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Center(
                      child: Text("قيم الآن",
                        style: GoogleFonts.lexend(
                          color: Colors.white,
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  );
}