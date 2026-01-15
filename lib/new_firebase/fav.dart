import 'package:appwidgetflutter/ads_manager.dart';
import 'package:appwidgetflutter/common/backgorund_image.dart';
import 'package:appwidgetflutter/utills/check_internet.dart';
import 'package:appwidgetflutter/utills/images_sources.dart';
import 'package:appwidgetflutter/new_firebase/services/favorites_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:share_plus/share_plus.dart';
import '../utills/colors_resources.dart';

class Favorite extends StatefulWidget {
  Favorite({Key? key}) : super(key: key);

  @override
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  List<String> favoriteVerses = [];
  NativeAd? _ad;
  bool isLoading = true;
  bool isLoadingFavorites = true;

  @override
  void initState() {
    super.initState();
    InternetCheck.checkingInternet();
    _loadFavorites();

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
          print('Ad load failed (code=${error.code} message=${error.message})');
        },
      ),
    );

    _ad!.load();
  }

  Future<void> _loadFavorites() async {
    final favorites = await FavoritesService.getFavorites();
    setState(() {
      favoriteVerses = favorites;
      isLoadingFavorites = false;
    });
  }

  Future<void> _removeFavorite(String verse) async {
    await FavoritesService.removeFavorite(verse);
    await _loadFavorites();
  }

  @override
  void dispose() {
    _ad?.dispose();
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
                      isLoadingFavorites
                        ? Expanded(
                            child: Center(
                              child: CircularProgressIndicator(
                                color: ColorResources.THEMECOLOR,
                              ),
                            ),
                          )
                        : favoriteVerses.isEmpty
                          ? Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(Images.grid_bottom, height: 50.0),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Text(
                                      "أضف هذا التصنيف الى الويدجت",
                                      style: GoogleFonts.cairo(
                                        color: ColorResources.THEMECOLOR,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Expanded(
                              child: ListView.builder(
                                itemCount: favoriteVerses.length,
                                padding: EdgeInsets.only(bottom: 80.0),
                                itemBuilder: (BuildContext context, int index) {
                                  final verse = favoriteVerses[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                      vertical: 8.0,
                                    ),
                                    child: Card(
                                      elevation: 4,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15.0),
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.all(16.0),
                                        child: Column(
                                          children: [
                                            // Verse text
                                            Text(
                                              verse,
                                              textAlign: TextAlign.center,
                                              textDirection: TextDirection.rtl,
                                              style: GoogleFonts.cairo(
                                                fontSize: 18.0,
                                                color: ColorResources.BOTTOM_BAR_SELECTED,
                                                fontWeight: FontWeight.w500,
                                                height: 1.8,
                                              ),
                                            ),
                                            SizedBox(height: 12),
                                            // Action buttons
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                // Share button
                                                Expanded(
                                                  child: InkWell(
                                                    onTap: () async {
                                                      await Share.share(verse, subject: 'آية قرآنية');
                                                    },
                                                    child: Container(
                                                      padding: EdgeInsets.symmetric(vertical: 10),
                                                      decoration: BoxDecoration(
                                                        color: ColorResources.THEMECOLOR.withAlpha((0.1 * 255).toInt()),
                                                        borderRadius: BorderRadius.circular(10),
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Icon(Icons.share, color: ColorResources.THEMECOLOR, size: 20),
                                                          SizedBox(width: 6),
                                                          Text(
                                                            'مشاركة',
                                                            style: GoogleFonts.cairo(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w600,
                                                              color: ColorResources.THEMECOLOR,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 12),
                                                // Remove from favorites button
                                                Expanded(
                                                  child: InkWell(
                                                    onTap: () async {
                                                      await _removeFavorite(verse);
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        SnackBar(
                                                          content: Text('تمت الإزالة من المفضلة'),
                                                          backgroundColor: ColorResources.THEMECOLOR,
                                                          duration: Duration(seconds: 1),
                                                        ),
                                                      );
                                                    },
                                                    child: Container(
                                                      padding: EdgeInsets.symmetric(vertical: 10),
                                                      decoration: BoxDecoration(
                                                        color: Colors.red.withAlpha((0.1 * 255).toInt()),
                                                        borderRadius: BorderRadius.circular(10),
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Icon(Icons.delete, color: Colors.red, size: 20),
                                                          SizedBox(width: 6),
                                                          Text(
                                                            'إزالة',
                                                            style: GoogleFonts.cairo(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w600,
                                                              color: Colors.red,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
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
