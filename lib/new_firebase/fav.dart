import 'package:appwidgetflutter/ads_manager.dart';
import 'package:appwidgetflutter/common/backgorund_image.dart';
import 'package:appwidgetflutter/dashboard/models/add_aya_model.dart';
import 'package:appwidgetflutter/utills/check_internet.dart';
import 'package:appwidgetflutter/utills/images_sources.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import '../utills/colors_resources.dart';
import 'providers/fav_categories_manager.dart';

class Favorite extends StatefulWidget {
  Favorite({Key? key}) : super(key: key);

  @override
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  List<AddAyaModel> favAyas = [];
  NativeAd? _ad;
  bool isLoading = true;
  @override
  void initState() {
    InternetCheck.checkingInternet();
    Provider.of<FavCategoryManager>(context, listen: false).getFavAya();
    var favAya = Provider.of<FavCategoryManager>(context, listen: false).getFavModel;
    favAya.forEach((element) { 
      favAyas.insert(0,element);
    });
    if(InternetCheck.isConnected){
      AdsManager.showInterstitialAd(adsId: AdsManager.getFavouritePageInterstitialAdUnitId()!);
    }
    _ad = NativeAd(
    adUnitId: "ca-app-pub-2692469317826110/7043323449",
    factoryId: 'listTile',
    request: AdRequest(),
    listener: NativeAdListener(
      onAdLoaded: (ad) {
        setState(() {
          _ad = ad as NativeAd;
          isLoading = false;
        });
      },
      onAdFailedToLoad: (ad, error) {
        // Releases an ad resource when it fails to load
        // ad.dispose();
        print('Ad load failed (code=${error.code} message=${error.message})');       },
    ),
  );

  _ad!.load();

    super.initState();
  }
  @override
  void dispose() {
    _ad!.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          BackgroundImage(
            child: SafeArea(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(onPressed: (){
                          Navigator.of(context).pop();
                        }, 
                        icon: Icon(Icons.arrow_back,
                         color: ColorResources.THEMECOLOR,                  
                        )),
                      ),
                      favAyas.length == 0? 
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(Images.grid_bottom, height: 50.0,),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text(
                                "لم تتم إضافة أي مفضلات",
                                style: GoogleFonts.lexend(
                                  color: ColorResources.THEMECOLOR,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ) :
                      Expanded(
                      child: ListView.builder(
                        itemCount: favAyas.length,
                        padding: EdgeInsets.only(
                          bottom: 50.0,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                              ),
                              title: InkResponse(
                            onTap: () async {
                            },
                            child: Card(
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 22.0),
                                child: Text(favAyas[index].aya!,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.lexend(
                                      fontSize: 20.0,
                                      color: ColorResources.BOTTOM_BAR_SELECTED,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          isLoading ? Container():
          Container(
            color: ColorResources.WHITE,
            height: 72.0,
            child: AdWidget(ad: _ad!),
          ),
        ],
      ),
    );
  }
}
