import 'package:appwidgetflutter/ads_manager.dart';
import 'package:appwidgetflutter/common/share_prefs.dart';
import 'package:appwidgetflutter/dashboard/models/add_aya_model.dart';
import 'package:appwidgetflutter/mobile_provider/circle_button_provider.dart';
import 'package:appwidgetflutter/new_firebase/category_manager.dart';
import 'package:appwidgetflutter/new_firebase/on_boarding_screen.dart';
import 'package:appwidgetflutter/new_firebase/share_screen.dart';
import 'package:appwidgetflutter/routes/router.dart';
import 'package:appwidgetflutter/utills/all_text.dart';
import 'package:appwidgetflutter/utills/colors_resources.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive/hive.dart';
import 'package:home_widget/home_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../firebase_options.dart';
import '../utills/images_sources.dart';
import '../utills/constants.dart';
import 'new_firebase/category_gallery.dart';
import 'new_firebase/home.dart';
import 'new_firebase/providers/fav_categories_manager.dart';

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
              builder: (context) => CategoryManager(
                category: category,
                categoryId: categoryId,
                index: index,
              ),
            ),
          );
        }
      } else if (uri.host == "favourite") {
        final category = await HomeWidget.getWidgetData('category');
        final categoryId = await HomeWidget.getWidgetData('categoryId');
        final index = await HomeWidget.getWidgetData("index");
        var favCatManager = Provider.of<FavCategoryManager>(
          context,
          listen: false,
        );
        final aya = await HomeWidget.getWidgetData('favourite');
        if (aya != null) {
          List<AddAyaModel> ayaList = AddAyaModel.decode(aya);
          bool isFav = getWallpapersOfCurrentCategory(
            ayaList[0],
            context,
            false,
          );
          if (isFav) {
            favCatManager.removeFromFav(ayaList[0]);
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(snackBar("إزالتها من المفضلة"));
          } else {
            favCatManager.addToFav(ayaList[0]);
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
              builder: (context) => CategoryManager(
                category: category,
                categoryId: categoryId,
                index: index,
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
        final categoryId = await HomeWidget.getWidgetData('categoryId');
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
              builder: (context) => CategoryManager(
                category: category,
                categoryId: categoryId,
                index: index,
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
