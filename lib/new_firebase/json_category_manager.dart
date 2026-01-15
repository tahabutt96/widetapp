import 'package:appwidgetflutter/ads_manager.dart';
import 'package:appwidgetflutter/common/back_button.dart';
import 'package:appwidgetflutter/common/backgorund_image.dart';
import 'package:appwidgetflutter/common/light_circle_button.dart';
import 'package:appwidgetflutter/dashboard/all_categories_widget.dart';
import 'package:appwidgetflutter/new_firebase/models/verse_model.dart';
import 'package:appwidgetflutter/new_firebase/services/json_service.dart';
import 'package:appwidgetflutter/new_firebase/services/favorites_service.dart';
import 'package:appwidgetflutter/utills/all_text.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:home_widget/home_widget.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utills/colors_resources.dart';

class JsonCategoryManager extends StatefulWidget {
  final String category;
  final int? initialIndex;
  final String? verseText; // Optional verse text for finding correct category

  JsonCategoryManager({
    Key? key,
    required this.category,
    this.initialIndex,
    this.verseText,
  }) : super(key: key);

  @override
  _JsonCategoryManagerState createState() => _JsonCategoryManagerState();
}

class _JsonCategoryManagerState extends State<JsonCategoryManager> {
  bool isLoadingBanner = false;
  BannerAd? _anchoredBanner;
  PageController? _controller;
  int currentIndex = 0;
  List<VerseModel> verses = [];
  bool isLoading = true;
  Map<int, bool> favoriteStates = {};
  String actualCategory = '';

  @override
  void initState() {
    super.initState();
    actualCategory = widget.category;
    _loadVerses();
    _loadBannerAd();
  }

  Future<void> _loadVerses() async {
    try {
      String categoryToUse = widget.category;
      int indexToUse = widget.initialIndex ?? 0;

      print('🔍 Loading verses for category: "$categoryToUse"');
      print('🔍 Verse text provided: "${widget.verseText}"');

      // First, try to load verses with the provided category
      var loadedVerses = await JsonService.getVersesByCategory(categoryToUse);

      // If no verses found and we have verse text, try to find the correct category
      if (loadedVerses.isEmpty && widget.verseText != null && widget.verseText!.isNotEmpty) {
        print('⚠️ No verses found for category "$categoryToUse", trying to find category from verse...');
        final foundCategory = await JsonService.findCategoryForVerse(widget.verseText!);
        if (foundCategory != null) {
          categoryToUse = foundCategory;
          loadedVerses = await JsonService.getVersesByCategory(categoryToUse);
          // Find the index of this verse in the category
          indexToUse = await JsonService.findVerseIndexInCategory(categoryToUse, widget.verseText!);
          print('✅ Found category: "$categoryToUse" with ${loadedVerses.length} verses, verse at index $indexToUse');
        }
      }

      // If still no verses, try to find category from verse text in widget data
      if (loadedVerses.isEmpty) {
        print('⚠️ Still no verses found, checking SharedPreferences for message...');
        final prefs = await SharedPreferences.getInstance();
        final message = prefs.getString('message') ?? prefs.getStringList('message')?.first;
        if (message != null && message.isNotEmpty) {
          print('📝 Found message in prefs: "${message.substring(0, message.length > 50 ? 50 : message.length)}..."');
          final foundCategory = await JsonService.findCategoryForVerse(message);
          if (foundCategory != null) {
            categoryToUse = foundCategory;
            loadedVerses = await JsonService.getVersesByCategory(categoryToUse);
            indexToUse = await JsonService.findVerseIndexInCategory(categoryToUse, message);
            print('✅ Found category from message: "$categoryToUse" with ${loadedVerses.length} verses');
          }
        }
      }

      // Load favorite states for all verses
      for (int i = 0; i < loadedVerses.length; i++) {
        favoriteStates[i] = await FavoritesService.isFavorite(loadedVerses[i].verse);
      }

      setState(() {
        verses = loadedVerses;
        actualCategory = categoryToUse;
        isLoading = false;
        currentIndex = indexToUse < loadedVerses.length ? indexToUse : 0;
        _controller = PageController(initialPage: currentIndex);
      });

      print('✅ Loaded ${verses.length} verses for category "$actualCategory", starting at index $currentIndex');
    } catch (e) {
      print('❌ Error loading verses: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _loadBannerAd() {
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
          ad.dispose();
          print('Ad load failed (code=${error.code} message=${error.message})');
        },
      ),
    ).load();
  }

  Future<void> _addToWidget() async {
    if (verses.isEmpty) return;

    final List<String> verseTexts = verses.map((v) => v.verse).toList();
    final categoryToSave = actualCategory.isNotEmpty ? actualCategory : widget.category;

    await HomeWidget.saveWidgetData("category", categoryToSave);
    await HomeWidget.saveWidgetData("message", verseTexts[currentIndex]);
    await HomeWidget.saveWidgetData("index", currentIndex);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('message', verseTexts);
    await prefs.setString('Category', categoryToSave);

    await HomeWidget.updateWidget(
      androidName: "AppWidgetProvider",
      iOSName: "AppWidgetProvider",
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("تمت إضافة هذه الآية إلى الويدجت"),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    _anchoredBanner?.dispose();
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
              bottom: false,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  children: [
                    // Back button
                    BackButtonWidget(),

                    // Add to widget button
                    InkWell(
                      onTap: _addToWidget,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        margin: EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: ColorResources.THEMECOLOR,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "إضافة للويدجت",
                              style: GoogleFonts.cairo(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Category name
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        actualCategory.isNotEmpty ? actualCategory : widget.category,
                        style: GoogleFonts.cairo(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: ColorResources.BOTTOM_BAR_SELECTED,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    // Main content
                    Expanded(
                      child: isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                color: ColorResources.THEMECOLOR,
                              ),
                            )
                          : verses.isEmpty
                              ? Center(
                                  child: Text(
                                    "لا توجد آيات في هذه الفئة",
                                    style: GoogleFonts.cairo(
                                      fontSize: 18,
                                      color: ColorResources.THEMECOLOR,
                                    ),
                                  ),
                                )
                              : Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Left arrow
                                    Container(
                                      margin: EdgeInsets.only(top: 15.0),
                                      height: MediaQuery.of(context).size.height / 1.7,
                                      alignment: Alignment.center,
                                      child: CircleButton(
                                        showColor: currentIndex > 0,
                                        onPressed: () {
                                          if (currentIndex > 0) {
                                            _controller!.previousPage(
                                              duration: Duration(milliseconds: 500),
                                              curve: Curves.easeOut,
                                            );
                                          }
                                        },
                                        direction: Direction.left,
                                      ),
                                    ),

                                    // Verses PageView
                                    Expanded(
                                      flex: 8,
                                      child: PageView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: verses.length,
                                        controller: _controller,
                                        onPageChanged: (value) {
                                          setState(() {
                                            currentIndex = value;
                                          });
                                        },
                                        itemBuilder: (BuildContext context, int index) {
                                          final verse = verses[index];
                                          final isFav = favoriteStates[index] ?? false;

                                          return ListView(
                                            physics: BouncingScrollPhysics(),
                                            padding: EdgeInsets.only(bottom: 50.0),
                                            children: [
                                              Container(
                                                alignment: Alignment.center,
                                                child: ExpandableNotifier(
                                                  child: ScrollOnExpand(
                                                    scrollOnExpand: false,
                                                    child: Card(
                                                      margin: EdgeInsets.only(
                                                        top: 15.0,
                                                        left: 10.0,
                                                        right: 10.0,
                                                      ),
                                                      elevation: 0.1,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(20),
                                                      ),
                                                      clipBehavior: Clip.antiAlias,
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: <Widget>[
                                                          Padding(
                                                            padding: EdgeInsets.only(
                                                              left: 15,
                                                              right: 15,
                                                              top: 15,
                                                            ),
                                                            child: Expandable(
                                                              collapsed: Container(
                                                                height: MediaQuery.of(context).size.height / 1.9,
                                                                alignment: Alignment.center,
                                                                child: Padding(
                                                                  padding: EdgeInsets.only(top: 10.0),
                                                                  child: Text(
                                                                    verse.verse,
                                                                    maxLines: 12,
                                                                    textAlign: TextAlign.center,
                                                                    textDirection: TextDirection.rtl,
                                                                    style: GoogleFonts.cairo(
                                                                      color: ColorResources.BOTTOM_BAR_SELECTED,
                                                                      fontSize: 18,
                                                                      fontWeight: FontWeight.w600,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              expanded: Container(
                                                                alignment: Alignment.center,
                                                                height: verse.verse.length < 200
                                                                    ? MediaQuery.of(context).size.height / 1.7
                                                                    : null,
                                                                child: Text(
                                                                  verse.verse,
                                                                  textAlign: TextAlign.center,
                                                                  textDirection: TextDirection.rtl,
                                                                  style: GoogleFonts.cairo(
                                                                    color: ColorResources.BOTTOM_BAR_SELECTED,
                                                                    fontSize: 18,
                                                                    fontWeight: FontWeight.w600,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          // Surah name
                                                          if (verse.surah.isNotEmpty)
                                                            Container(
                                                              width: double.infinity,
                                                              padding: EdgeInsets.symmetric(
                                                                vertical: 8,
                                                                horizontal: 16,
                                                              ),
                                                              color: ColorResources.THEMECOLOR.withAlpha((0.1 * 255).toInt()),
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
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: <Widget>[
                                                              Builder(
                                                                builder: (context) {
                                                                  var controller = ExpandableController.of(
                                                                    context,
                                                                    required: true,
                                                                  )!;
                                                                  return IconButton(
                                                                    onPressed: () {
                                                                      controller.toggle();
                                                                    },
                                                                    icon: controller.expanded
                                                                        ? Icon(
                                                                            Icons.expand_less,
                                                                            color: ColorResources.BOTTOM_BAR_SELECTED,
                                                                          )
                                                                        : Icon(
                                                                            Icons.expand_more_outlined,
                                                                            color: ColorResources.BOTTOM_BAR_SELECTED,
                                                                          ),
                                                                  );
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 5),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 15.0,
                                                  vertical: 7.0,
                                                ),
                                                child: Row(
                                                  children: [
                                                    // Share button
                                                    LightCircleButton(
                                                      onPressed: () async {
                                                        await Share.share(
                                                          '${verse.verse}\n\n${verse.surah}\n\n${AllText.appLink}',
                                                          subject: widget.category,
                                                        );
                                                      },
                                                      icon: Icons.share,
                                                    ),
                                                    SizedBox(width: 10.0),
                                                    // Favorite button
                                                    LightCircleButton(
                                                      onPressed: () async {
                                                        final newState = await FavoritesService.toggleFavorite(verse.verse);
                                                        setState(() {
                                                          favoriteStates[index] = newState;
                                                        });
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                              newState
                                                                  ? "تمت الإضافة إلى المفضلة"
                                                                  : "تمت الإزالة من المفضلة",
                                                            ),
                                                            backgroundColor: ColorResources.THEMECOLOR,
                                                            duration: Duration(seconds: 1),
                                                          ),
                                                        );
                                                      },
                                                      icon: isFav ? Icons.favorite : Icons.favorite_border,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),

                                    // Right arrow
                                    Container(
                                      margin: EdgeInsets.only(top: 15.0),
                                      height: MediaQuery.of(context).size.height / 1.7,
                                      alignment: Alignment.center,
                                      child: CircleButton(
                                        showColor: currentIndex < verses.length - 1,
                                        onPressed: () {
                                          if (currentIndex < verses.length - 1) {
                                            _controller!.nextPage(
                                              duration: Duration(milliseconds: 500),
                                              curve: Curves.easeIn,
                                            );
                                          }
                                        },
                                        direction: Direction.right,
                                      ),
                                    ),
                                  ],
                                ),
                    ),

                    // Verse counter
                    if (!isLoading && verses.isNotEmpty)
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          '${currentIndex + 1} / ${verses.length}',
                          style: GoogleFonts.cairo(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: ColorResources.THEMECOLOR,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          // Banner Ad
          if (isLoadingBanner && _anchoredBanner != null)
            Container(
              width: _anchoredBanner!.size.width.toDouble(),
              height: _anchoredBanner!.size.height.toDouble(),
              child: AdWidget(ad: _anchoredBanner!),
            ),
        ],
      ),
    );
  }
}

// Snackbar helper
SnackBar snackBar(String message) {
  return SnackBar(
    content: Text(message),
    backgroundColor: ColorResources.THEMECOLOR,
    duration: Duration(seconds: 1),
  );
}
