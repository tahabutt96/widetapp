import 'dart:async';

import 'package:appwidgetflutter/ads_manager.dart';
import 'package:appwidgetflutter/common/add_category_button.dart';
import 'package:appwidgetflutter/common/back_button.dart';
import 'package:appwidgetflutter/common/backgorund_image.dart';
import 'package:appwidgetflutter/common/light_circle_button.dart';
import 'package:appwidgetflutter/common/share_prefs.dart';
import 'package:appwidgetflutter/dashboard/all_categories_widget.dart';
import 'package:appwidgetflutter/dashboard/models/add_aya_model.dart';
import 'package:appwidgetflutter/main.dart';
import 'package:appwidgetflutter/mobile_provider/circle_button_provider.dart';
import 'package:appwidgetflutter/new_firebase/providers/fav_categories_manager.dart';
import 'package:appwidgetflutter/utills/all_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:home_widget/home_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utills/colors_resources.dart';
import 'package:flutter_share/flutter_share.dart';
class CategoryManager extends StatefulWidget {
  final String? categoryId;
  final String? category;
  final int? index;
  CategoryManager({Key? key, required this.category, this.categoryId,this.index})
      : super(key: key);

  @override
  _CategoryManagerState createState() => _CategoryManagerState();
}
class _CategoryManagerState extends State<CategoryManager> {
  
  bool isLoadingBanner = false;
  late BannerAdListener bannerAdListener;
  BannerAd? _anchoredBanner;
  PageController? _controller;
  int currentIndex = 0;
  static int selectedTextIndex = 0;
  @pragma('vm:entry-point')
  static void onStart(ServiceInstance serviceInstance) async{
    final service = FlutterBackgroundService();
  
  Timer.periodic(Duration(seconds: 3), (timer) async {
    
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.reload();
    final message = await sharedPreferences.getStringList('message');
    final String list = sharedPreferences.getString("ayaList")!;
    List<AddAyaModel> ayaList = AddAyaModel.decode(list);
    sharedPreferences.reload();
    print(message);
      if(selectedTextIndex < message!.length) {
        print("this is index");
        print(ayaList[selectedTextIndex]);
        HomeWidget.saveWidgetData("message", message[selectedTextIndex]);
        HomeWidget.saveWidgetData("favourite", AddAyaModel.encode([ayaList[selectedTextIndex]]));
        HomeWidget.saveWidgetData("index", selectedTextIndex);
        HomeWidget.updateWidget(androidName: "AppWidgetProvider",iOSName: "AppWidgetProvider");
        selectedTextIndex++;
      }
      else {
        selectedTextIndex = 0;
        HomeWidget.saveWidgetData("message", message[0]);
        HomeWidget.saveWidgetData("favourite", ayaList[0].toString());
        HomeWidget.saveWidgetData("index", selectedTextIndex);
        HomeWidget.updateWidget(androidName: "AppWidgetProvider",iOSName: "AppWidgetProvider");
      }
    if (!(await service.startService())) timer.cancel();
  });
}
  Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: true,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(),
  );
  }
  @override
  void initState() {
    final length = Provider.of<CircleButtonProvider>(context, listen: false);
    if(length.getForwardCounter == 1){
     length.setForwardCounter(widget.categoryId!);
    }
    if(widget.index!=0 && widget.index!=null){
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) { 
         length.setcounterfromFav(widget.index!);
      });
    }
    _controller = PageController(initialPage: widget.index??0);
    _checkIfCategoryIsAdded();
    BannerAd(
    adUnitId: AdsManager.getBannerAdUnitId()!,
    size: AdSize.banner,
    request: AdRequest(),
    listener: BannerAdListener(
      onAdLoaded: (ad) {
        setState(() {
          _anchoredBanner = ad as BannerAd;
          isLoadingBanner = true;
        });
      },
      onAdFailedToLoad: (ad, error) {
        // Releases an ad resource when it fails to load
        ad.dispose();
        print('Ad load failed (code=${error.code} message=${error.message})');
      },
    ),
  ).load();
    AdsManager.createInterstitialAd(adsId: AdsManager.getCategoryButtonPressedInterstitialAdUnitId()!);
    super.initState();
  }
  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }
  bool isAdded = false;
    _checkIfCategoryIsAdded() async {
      final categoryId = await HomeWidget.getWidgetData('categoryId');
      print(categoryId);
      print(widget.categoryId);
      setState(() {
        if(categoryId == widget.categoryId) {
          isAdded = true;
        }
      });
    }
  @override
  Widget build(BuildContext context) {
    List<AddAyaModel> allAya = [];
    final circleButtonProvider = Provider.of<CircleButtonProvider>(context);
    var favCatManager = Provider.of<FavCategoryManager>(context);
    
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          BackgroundImage(
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  children: [
                    BackButtonWidget(),
                  AddCategoryToWidgetButton(
                    color: isAdded ? Colors.green : null,
                    text: isAdded ? "تمت إضافة هذه الآية إلى القطعة" : null,
                    onPressed: () async {
                      final List<String> list = [];
                      allAya.forEach((e) {
                        list.add(e.aya!);
                      });
                      HomeWidget.saveWidgetData("category", widget.category);
                      SharePrefs.setMessage(list);
                      SharePrefs.setListAya(AddAyaModel.encode(allAya));
                      HomeWidget.saveWidgetData("message", list[0]);
                      print(list);
                      print('okay done');
                      HomeWidget.saveWidgetData("categoryId", widget.categoryId);
                      SharePrefs.setCategory(widget.category!);
                      _checkIfCategoryIsAdded();
                      HomeWidget.updateWidget(androidName: "AppWidgetProvider",iOSName: "AppWidgetProvider").then((value){
                        setState(() {
                          if(list.length > 1) {
                            selectedTextIndex = 1;
                          }else{
                            selectedTextIndex = 0;
                          }
                          initializeService();
                          AdsManager.showInterstitialAd(adsId: AdsManager.getCategoryButtonPressedInterstitialAdUnitId()!);
                        });
                      });
                      
                    },
                  ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
          Container(
            margin: EdgeInsets.only(top: 15.0),
            height: MediaQuery.of(context).size.height/1.7,
            alignment: Alignment.center,
            child: CircleButton(
              showColor: circleButtonProvider.getPrevioisCounter > 1 ? true: false,
              onPressed: (){
                if(circleButtonProvider.getPrevioisCounter > 1){
                  _controller!.previousPage(duration: Duration(
                    milliseconds: 500,
                  ), 
                  curve: Curves.easeOut);
                }
                circleButtonProvider.decrementForwardCounter();
            }, 
            direction: Direction.left),
          ),
    StreamBuilder(
          stream: FirebaseFirestore.instance.collection('aya').
          doc(widget.categoryId).collection('cataya').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              allAya = snapshot.data!.docs.map((e) => 
              AddAyaModel.fromJson(e.data()! as Map<String,dynamic>)).toList();
              return Expanded(
                flex: 8,
                child: PageView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: allAya.length,
                  controller: _controller,
                  onPageChanged: (value) {
                    currentIndex = value;
                  },
                  itemBuilder: (BuildContext context, int index) {
                    bool isFav = getWallpapersOfCurrentCategory(allAya[index],context,true);
                    return ListView(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.only(
                        bottom: 50.0
                      ),
                      children: [
                        Container(
                        alignment: Alignment.center,
                          child: ExpandableNotifier(
                          child: ScrollOnExpand(
                          scrollOnExpand: false,
                          child: Card(
                            margin: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
                            elevation: 0.1,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                                  child: Expandable(
                                    collapsed: Container(
                                      height: MediaQuery.of(context).size.height/1.9,
                                      alignment: Alignment.center,
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 10.0),
                                        child: Text(allAya[index].aya!,
                                          maxLines: 12,
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.lexend(
                                            color: ColorResources.BOTTOM_BAR_SELECTED,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600),
                                          ),
                                      ),
                                      ),
                                      expanded: Container(
                                        alignment: Alignment.center,
                                        height:allAya[index].aya!.length<200? MediaQuery.of(context).size.height/1.7 : null,
                                        child: Text(
                                          allAya[index].aya!,
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.lexend(
                                          color: ColorResources.BOTTOM_BAR_SELECTED,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600
                                          ),
                                        ),
                                      ),
                                    )),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Builder(
                                        builder: (context) {
                                          var controller = ExpandableController.of(context, required: true)!;
                                          return IconButton(
                                            onPressed: () {
                                              controller.toggle();
                                            },
                                            icon: controller.expanded ? Icon(
                                              Icons.expand_less,
                                              color: ColorResources.BOTTOM_BAR_SELECTED,
                                              ) : 
                                              Icon(Icons.expand_more_outlined,
                                                color: ColorResources.BOTTOM_BAR_SELECTED));
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                                ),
                               ),
                              ),
                            )),
                                SizedBox(width: 5),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 7.0),
                                  child: Row(
                                    children: [
                                      LightCircleButton(
                                          onPressed: () async{
                                            await FlutterShare.share(
                                            title: widget.category!,
                                            text: allAya[index].aya.toString() + AllText.appLink,
                                            chooserTitle: 'Quran App');
                                          }, 
                                          icon: Icons.share,
                                        ),
                                      SizedBox(width: 10.0,),
                                      LightCircleButton(
                                          onPressed: () {
                                          if (isFav) {
                                            favCatManager.removeFromFav(allAya[index]);
                                            ScaffoldMessenger.of(context).showSnackBar(snackBar("تمت الإزالة من المفضلة"));
                                            
                                          } else {
                                            ScaffoldMessenger.of(context).showSnackBar(snackBar("تمت الإضافة إلى المفضلة"));
                                            favCatManager.addToFav(allAya[index]);
                                          }
                                          isFav =
                                              !isFav;
                                          }, 
                                          icon: isFav
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                        ),
                                    ],
                                  ),  
                                ),
                                        ],
                                      );
                                    },
                                  ),
                                );
                              } else {
                                return Expanded(
                                  flex: 7,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: ColorResources.THEMECOLOR,
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 15.0),
                            height: MediaQuery.of(context).size.height/1.7,
                            alignment: Alignment.center,
                            child: CircleButton(
                              showColor: circleButtonProvider.getForwardCounter > 1 ? true: false,
                              onPressed: (){
                                if(circleButtonProvider.getForwardCounter > 1) {
                                  _controller!.nextPage(duration: Duration(
                                    milliseconds: 500,
                                  ), 
                                  curve: Curves.easeIn);
                                  circleButtonProvider.inCrementPreviousCounter();
                                  
                                print(circleButtonProvider.getForwardCounter);
                                }
                            }, direction: Direction.right,),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
            isLoadingBanner ?
            Container(
              width: _anchoredBanner!.size.width.toDouble(),
              height: _anchoredBanner!.size.height.toDouble(),
              child: AdWidget(ad: _anchoredBanner!)):
            Container()
        ],
      ),
    );
  }

  
}
bool getWallpapersOfCurrentCategory(AddAyaModel ayaModel,context, bool listen) {

    var favCatManager = Provider.of<FavCategoryManager>(context,listen: listen);
    if(favCatManager.isFavorite(ayaModel)) {
        return true;
    }
    else {
      return false;
    } 
  }


