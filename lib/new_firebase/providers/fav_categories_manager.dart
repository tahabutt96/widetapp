import 'package:appwidgetflutter/dashboard/models/add_aya_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../utills/constants.dart';

class FavCategoryManager extends ChangeNotifier {
  List<AddAyaModel> favAyaModel = [];
  List<AddAyaModel> get getFavModel => favAyaModel;
  
  getFavAya() async{
    final box = Boxes.getFavorites();
    favAyaModel = box.values.toList().cast<AddAyaModel>();
  }
  
  void addToFav(AddAyaModel aya) async {
    final box = Boxes.getFavorites();
      box.add(aya);
      notifyListeners();
  }

  void removeFromFav(AddAyaModel aya) {
    final box = Boxes.getFavorites();
    final Map<dynamic, AddAyaModel> favouritesMap = box.toMap();
    dynamic desiredKey;
    favouritesMap.forEach((key, value){
        if (value.id == aya.id)
        desiredKey = key;
    });
    box.delete(desiredKey);
    notifyListeners();
  }

  bool isFavorite(AddAyaModel aya) {
    final box = Boxes.getFavorites();
    final Map<dynamic, AddAyaModel> favouritesMap = box.toMap();
    dynamic desiredKey;
    favouritesMap.forEach((key, value){
        if (value.id == aya.id)
        desiredKey = key;
    });
    if(box.keys.contains(desiredKey)) {
      return true;
    } else {
      return false;
    }
  }
}

class Boxes {
  static Box<AddAyaModel> getFavorites() =>
      Hive.box<AddAyaModel>(FAV_BOX);
}