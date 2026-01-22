import 'dart:async';

import 'package:appwidgetflutter/ads_manager.dart';
import 'package:appwidgetflutter/common/share_prefs.dart';
import 'package:appwidgetflutter/dashboard/models/add_aya_model.dart';
import 'package:appwidgetflutter/mobile_provider/circle_button_provider.dart';
import 'package:appwidgetflutter/new_firebase/json_category_manager.dart';
import 'package:appwidgetflutter/new_firebase/services/favorites_service.dart';
import 'package:appwidgetflutter/new_firebase/on_boarding_screen.dart';
import 'package:appwidgetflutter/new_firebase/share_screen.dart';
import 'package:appwidgetflutter/routes/router.dart';
import 'package:appwidgetflutter/utills/all_text.dart';
import 'package:appwidgetflutter/utills/colors_resources.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:share_plus/share_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive/hive.dart';
import 'package:home_widget/home_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../firebase_options.dart';
import '../utills/images_sources.dart';
import '../utills/constants.dart';
import 'new_firebase/category_gallery.dart';
import 'new_firebase/home.dart';
import 'new_firebase/providers/fav_categories_manager.dart';

// Background service entry point - MUST be top-level function
@pragma('vm:entry-point')
void onBackgroundServiceStart(ServiceInstance serviceInstance) async {
  WidgetsFlutterBinding.ensureInitialized();
  print('🚀 Background service started');

  // Update every 5 seconds (for testing - change to Duration(minutes: 5) for production)
  Timer.periodic(Duration(minutes: 5), (timer) async {
    try {
      print('⏰ Background service tick');

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.reload();

      final messages = prefs.getStringList('message');
      print('📱 Messages count: ${messages?.length ?? 0}');

      if (messages == null || messages.isEmpty) {
        print('⚠️ No messages found');
        return;
      }

      // Get current index
      int currentIdx = prefs.getInt('widgetVerseIndex') ?? 0;
      print('📱 Current index: $currentIdx');

      // Make sure index is valid
      if (currentIdx >= messages.length) {
        currentIdx = 0;
      }

      // Update widget with current verse
      final currentMessage = messages[currentIdx];
      print('📱 Updating widget with verse index $currentIdx');

      await HomeWidget.saveWidgetData<String>("message", currentMessage);
      await HomeWidget.saveWidgetData<int>("index", currentIdx);

      await HomeWidget.updateWidget(
        name: "AppWidgetProvider",
        androidName: "AppWidgetProvider",
        iOSName: "AppWidgetProvider",
      );
      print('📱 Widget updated successfully');

      // Move to next verse for next update
      currentIdx++;
      if (currentIdx >= messages.length) {
        currentIdx = 0;
      }
      await prefs.setInt('widgetVerseIndex', currentIdx);
      print('📱 Next index set to: $currentIdx');

    } catch (e, stackTrace) {
      print('❌ Background service error: $e');
      print('❌ Stack trace: $stackTrace');
    }
  });
}

// Initialize background service
Future<void> initializeBackgroundService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onBackgroundServiceStart,
      autoStart: false, // Don't auto start - we start it when user adds to widget
      isForegroundMode: true,
      initialNotificationTitle: 'معي ربي',
      initialNotificationContent: 'جاري تحديث الآيات',
    ),
    iosConfiguration: IosConfiguration(
      autoStart: false,
      onForeground: onBackgroundServiceStart,
    ),
  );
  print('✅ Background service configured');
}

Future<void> main() async {
  await _initApp();
  MobileAds.instance.initialize();
  AdsManager.createInterstitialAd(
    adsId: AdsManager.getFavouritePageInterstitialAdUnitId()!,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavCategoryManager()),
        ChangeNotifierProvider(create: (_) => CircleButtonProvider()),
      ],
      child: MainPage(),
    ),
  );
}

Future<void> backgroundCallback(Uri? uri) async {
  print(uri!.data);
  if (uri.host == 'updatecounter') {
    int _counter = 0;
    await HomeWidget.getWidgetData<int>('_counter', defaultValue: 0).then((
      value,
    ) {
      _counter = value!;
      _counter++;
    });
    await HomeWidget.saveWidgetData<int>('_counter', _counter);
    await HomeWidget.updateWidget(
      name: 'AppWidgetProvider',
      iOSName: 'AppWidgetProvider',
    );
  }
}

Future _initApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  HomeWidget.registerBackgroundCallback(backgroundCallback);

  // Initialize background service for widget auto-update
  await initializeBackgroundService();

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  SharePrefs.init().then((value) {
    final sliderValue = SharePrefs.getSliderValue();
    SharePrefs.setSliderValue(sliderValue ?? true);
  });
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Firebase.initializeApp();

  var docDir = await getApplicationDocumentsDirectory();
  Hive.init(docDir.path);
  Hive.registerAdapter<AddAyaModel>(AddAyaAdaptor());

  Hive.openBox<AddAyaModel>(FAV_BOX);

  var settings = await Hive.openBox(SETTINGS);
  if (settings.get(DARK_THEME_KEY) == null) {
    settings.put(DARK_THEME_KEY, false);
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool sliderValue = SharePrefs.getSliderValue()!;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quran',
      onGenerateRoute: AppRouter.generateRoute,
      navigatorKey: AppRouter.navigatorKey,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: sliderValue
          ? OnBoardingScreen()
          : MyHomePage(selectedIndex: 2, info: "home"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final int selectedIndex;
  final String info;
  MyHomePage({
    Key? key,
    this.title,
    required this.selectedIndex,
    required this.info,
  }) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late PageController pageController;
  bool? isDrawerToBeOpen;
  final _selectedItemColor = Colors.white;
  final _unselectedItemColor = ColorResources.BOTTOM_BAR_SELECTED;
  final _selectedBgColor = ColorResources.BOTTOM_BAR_SELECTED;
  final _unselectedBgColor = ColorResources.BOTTOM_BAR;
  int _selectedIndex = 2;
  Color _getBgColor(int index) =>
      _selectedIndex == index ? _selectedBgColor : _unselectedBgColor;

  Color _getItemColor(int index) =>
      _selectedIndex == index ? _unselectedBgColor : _unselectedItemColor;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      print('current index: $index ,, slected index: $_selectedIndex');
      pageController.animateToPage(
        _selectedIndex,
        curve: Curves.fastOutSlowIn,
        duration: Duration(milliseconds: 100),
      );
      isDrawerToBeOpen = false;
    });
  }

  Widget _buildIcon(Image iconData, String text, int index) => Container(
        width: 85,
        height: 58,
        padding: EdgeInsets.only(bottom: 5),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(6.0),
              bottomRight: Radius.circular(6.0),
            ),
            color: _getBgColor(index),
          ),
          child: InkWell(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                iconData,
                Text(
                  text,
                  style: TextStyle(fontSize: 12, color: _getItemColor(index)),
                ),
              ],
            ),
            onTap: () => _onItemTapped(index),
          ),
        ),
      );
  @override
  void initState() {
    super.initState();
    setState(() {
      _selectedIndex = widget.selectedIndex;
      pageController = PageController(initialPage: widget.selectedIndex);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.info == "home") {
      HomeWidget.initiallyLaunchedFromHomeWidget().then(_launchedFromWidget);
    }
    HomeWidget.widgetClicked.listen((url) {
      print("Clicked");
      _launchedFromWidget(url);
    });
  }

  void _launchedFromWidget(Uri? uri) async {
    if (uri != null) {
      if (uri.host == "categoryid") {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => MyHomePage(selectedIndex: 1, info: "widget"),
          ),
          (route) => false,
        );

        AdsManager.createInterstitialAd(
          adsId: AdsManager.getWidgetPressedInterstitialAdUnitId()!,
        );
        AdsManager.showInterstitialAd(
          adsId: AdsManager.getWidgetPressedInterstitialAdUnitId()!,
        );
      } else if (uri.host == "share") {
        final category = await HomeWidget.getWidgetData('category');
        final categoryId = await HomeWidget.getWidgetData('categoryId');
        final index = await HomeWidget.getWidgetData("index");
        final aya = await HomeWidget.getWidgetData('message');
        print(aya);
        await Share.share(
          '${aya}\n\n${AllText.appLink}',
          subject: 'Quran App',
        );
        if (aya != null) {
          Provider.of<CircleButtonProvider>(
            context,
            listen: false,
          ).setCounters();
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) =>
                  MyHomePage(selectedIndex: 1, info: "widget"),
            ),
            (route) => false,
          );
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => JsonCategoryManager(
                category: category ?? '',
                initialIndex: index ?? 0,
                verseText: aya,
              ),
            ),
          );
        }
      } else if (uri.host == "favourite") {
        final category = await HomeWidget.getWidgetData('category');
        final index = await HomeWidget.getWidgetData("index");
        final aya = await HomeWidget.getWidgetData('message');
        if (aya != null) {
          // Toggle favorite using local FavoritesService
          bool isFav = await FavoritesService.isFavorite(aya);
          if (isFav) {
            await FavoritesService.removeFavorite(aya);
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(snackBar("إزالتها من المفضلة"));
          } else {
            await FavoritesService.addFavorite(aya);
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(snackBar("تمت الإضافة إلى المفضلة"));
          }
          Provider.of<CircleButtonProvider>(
            context,
            listen: false,
          ).setCounters();
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) =>
                  MyHomePage(selectedIndex: 1, info: "widget"),
            ),
            (route) => false,
          );
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => JsonCategoryManager(
                category: category ?? '',
                initialIndex: index ?? 0,
                verseText: aya,
              ),
            ),
          );
        }

        AdsManager.createInterstitialAd(
          adsId: AdsManager.getWidgetPressedInterstitialAdUnitId()!,
        );
        AdsManager.showInterstitialAd(
          adsId: AdsManager.getWidgetPressedInterstitialAdUnitId()!,
        );
      } else if (uri.host == "message") {
        final category = await HomeWidget.getWidgetData('category');
        final index = await HomeWidget.getWidgetData("index");
        final aya = await HomeWidget.getWidgetData('message');
        if (aya != null) {
          Provider.of<CircleButtonProvider>(
            context,
            listen: false,
          ).setCounters();
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) =>
                  MyHomePage(selectedIndex: 1, info: "widget"),
            ),
            (route) => false,
          );
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => JsonCategoryManager(
                category: category ?? '',
                initialIndex: index ?? 0,
                verseText: aya,
              ),
            ),
          );
        }

        AdsManager.createInterstitialAd(
          adsId: AdsManager.getWidgetPressedInterstitialAdUnitId()!,
        );
        AdsManager.showInterstitialAd(
          adsId: AdsManager.getWidgetPressedInterstitialAdUnitId()!,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildScaffold();
  }

  Scaffold _buildScaffold() {
    return Scaffold(
      body: PageView.builder(
        controller: pageController,
        itemCount: 3,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return _getPageAtIndex(index);
        },
        onPageChanged: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 0,
        backgroundColor: ColorResources.BOTTOM_BAR,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
            print(
              ' inside current index: $index ,, slected index: $_selectedIndex',
            );
          });
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: _buildIcon(
              Image.asset(
                Images.bottom_bar_1,
                height: 20,
                color: _selectedIndex == 0
                    ? ColorResources.BOTTOM_BAR
                    : ColorResources.BOTTOM_BAR_SELECTED,
              ),
              'شاركنا الثواب',
              0,
            ),
            label: '',
            backgroundColor: Color(0xFF038EC2),
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(
              Image.asset(
                Images.bottom_bar_2,
                height: 20,
                color: _selectedIndex == 1
                    ? ColorResources.BOTTOM_BAR
                    : ColorResources.BOTTOM_BAR_SELECTED,
              ),
              'التصنيفات',
              1,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(
              Image.asset(
                Images.bottom_bar_3,
                height: 20,
                color: _selectedIndex == 2
                    ? ColorResources.BOTTOM_BAR
                    : ColorResources.BOTTOM_BAR_SELECTED,
              ),
              'الرئيسية',
              2,
            ),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: _selectedItemColor,
        unselectedItemColor: _unselectedItemColor,
      ),
    );
  }

  Widget _getPageAtIndex(int index) {
    switch (index) {
      case 0:
        return ShareScreen(isShowBack: false);
      case 1:
        return Home();
      case 2:
        return CategoriesGallery();
      default:
        return CircularProgressIndicator();
    }
  }
}

SnackBar snackBar(String text) {
  return SnackBar(
    duration: Duration(seconds: 1),
    content: Text(
      text,
      textDirection: TextDirection.rtl,
      style: GoogleFonts.urbanist(fontSize: 18.0),
    ),
  );
}
