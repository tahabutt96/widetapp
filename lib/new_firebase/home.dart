import 'package:appwidgetflutter/common/backgorund_image.dart';
import 'package:appwidgetflutter/common/card_widget.dart';
import 'package:appwidgetflutter/common/menu_button.dart';
import 'package:appwidgetflutter/new_firebase/common/drawer_widget.dart';
import 'package:appwidgetflutter/new_firebase/fav.dart';
import 'package:appwidgetflutter/new_firebase/json_category_manager.dart';
import 'package:appwidgetflutter/new_firebase/models/category_item.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      selectedCategory = sp.getString('HomeSelectedCategory');
    });
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
                              // Update UI selection (use different key to avoid affecting dropdown)
                              SharedPreferences sp = await SharedPreferences.getInstance();
                              await sp.setString('HomeSelectedCategory', cat.name);

                              setState(() {
                                selectedCategory = cat.name;
                              });

                              // Navigate to JsonCategoryManager
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => JsonCategoryManager(
                                    category: cat.name,
                                  ),
                                ),
                              );
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