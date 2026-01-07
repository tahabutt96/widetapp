import 'package:appwidgetflutter/common/backgorund_image.dart';
import 'package:appwidgetflutter/common/card_widget.dart';
import 'package:appwidgetflutter/common/menu_button.dart';
import 'package:appwidgetflutter/dashboard/models/add_category_model.dart';
import 'package:appwidgetflutter/mobile_common/circular_progress_indicator.dart';
import 'package:appwidgetflutter/mobile_provider/circle_button_provider.dart';
import 'package:appwidgetflutter/new_firebase/common/drawer_widget.dart';
import 'package:appwidgetflutter/new_firebase/fav.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../utills/colors_resources.dart';
import '../utills/images_sources.dart';
import 'category_manager.dart';
import 'models/categories.dart';

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

  @override
  void initState() {
    super.initState();
  }
  List<String> list2 = [Images.grid_bottom];
  List<CategoriesModel>? wallpaperList;
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
                          "بماذا تشعر؟",
                          textDirection: TextDirection.rtl,
                          style: GoogleFonts.lexend(
                            fontWeight: FontWeight.w600,
                            fontSize: 25,
                            color: ColorResources.THEMECOLOR,
                        ),
                      ),
                      ),
                      StreamBuilder(
                        stream: FirebaseFirestore.instance.collection('categories').snapshots(),
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if(snapshot.hasData) {
                          List<AddCategoryModel> addCat = snapshot.data!.docs.map((e) => 
                          AddCategoryModel.fromJson(e.data()! as Map<String,dynamic>)).toList();
                          return Directionality(
                            textDirection: TextDirection.rtl,
                            child: Wrap(
                              runSpacing: 10.0,
                              spacing: 10.0,
                              children: addCat
                                  .map((cat) => InkResponse(
                                      onTap: () {
                                        Provider.of<CircleButtonProvider>(context,listen: false).setCounters();
                                        Navigator.push(context,
                                              MaterialPageRoute(builder: (context) {
                                            return CategoryManager(
                                                categoryId: cat.id,
                                                category: cat.category);
                                          }));
                                      },
                                      child: CategoryCardWidget(image: cat.image, title: cat.category)))
                                  .toList(),
                            ));
                          } else if(snapshot.data == null) {
                            return EmptyData();
                          } else if(snapshot.hasError) {
                            return ErrorText();
                          } else {
                            return CustomCircularProgressIndicator();
                          }
                        },
                      ),
                      
                      Container(
                          alignment: Alignment.topRight,
                          padding: EdgeInsets.only(top: 20, bottom: 10),
                          child: Text("مجموعتي",
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