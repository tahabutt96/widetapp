

import 'package:appwidgetflutter/dashboard/login_page.dart';
import 'package:appwidgetflutter/dashboard/provider/add_aya_provider.dart';
import 'package:appwidgetflutter/dashboard/provider/drawer_index_provider.dart';
import 'package:appwidgetflutter/dashboard/provider/get_all_aya_bycat.dart';
import 'package:appwidgetflutter/dashboard/provider/get_all_categories_provider.dart';
import 'package:appwidgetflutter/dashboard/provider/login_provider.dart';
import 'package:appwidgetflutter/dashboard/provider/on_drop_provider.dart';
import 'package:appwidgetflutter/dashboard/provider/upload_category_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyD2OfSU-VxqXTYnaedrbz_Vua4NonRO5Mg",
      authDomain: "arabic-9b31b.firebaseapp.com",
      databaseURL: "https://arabic-9b31b-default-rtdb.firebaseio.com",
      projectId: "arabic-9b31b",
      storageBucket: "arabic-9b31b.appspot.com",
      messagingSenderId: "998235973423",
      appId: "1:998235973423:web:c17b058097dc8b641b23da",
      measurementId: "G-0DK1E5PF0J"
    ),
  );
  runApp(
    MultiProvider(
      providers: [
      ChangeNotifierProvider(create: (_)=> DropFileProvider(),),
      ChangeNotifierProvider(create: (_)=> DrawerIndexProvider(),),
      ChangeNotifierProvider(create: (_)=> AddCategoryProvider(),),
      ChangeNotifierProvider(create: (_)=> GetAllCategoriesProvider(),),
      ChangeNotifierProvider(create: (_)=> AddAyaProvider()),
      ChangeNotifierProvider(create: (_)=> GetAllAyaByCategory()),
      ChangeNotifierProvider(create: (_)=> LoginProvider()),
    ],
    child: Dashboard(),
  ),
  );
}

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}