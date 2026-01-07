import 'package:appwidgetflutter/dashboard/controllers/firebase_controller.dart';
import 'package:appwidgetflutter/dashboard/error_handling/get_aya_state.dart';
import 'package:appwidgetflutter/dashboard/models/add_aya_model.dart';
import 'package:flutter/material.dart';

class GetAllAyaByCategory extends ChangeNotifier {
  List<AddAyaModel> ayaByCategory = [];
  List<AddAyaModel> get getAyaByCategory => ayaByCategory;
  bool isLoading = false;
  bool error = true;
  String message = "";
  Future getAllAyaModel(String catId) async{
    isLoading = true;
    error = false;
    message = "";
    notifyListeners();
    final GetAllAyaState allAya = await FirebaseController.getAllAyaByCategoryFromFirebase(catId: catId);
     if(allAya.success == false) {
       error = true;
       message = allAya.message;
       isLoading = false;
       notifyListeners();
     }
     else {
      ayaByCategory = allAya.result;
      forwardCounter = allAya.result.length;
      notifyListeners();
     }
     isLoading = false;
    notifyListeners();
  }

  deleteAyaModel(String catId,String ayaId) async{
    isLoading = true;
    error = false;
    message = "";
    notifyListeners();
    final bool allAya = await FirebaseController.deleteAyaByCategoryFromFirebase(catId: catId,ayaId: ayaId);
     if(allAya == true) {
      return true;
     }
     else {
      return false;
     }
  }

  String selectedCategoryName = "";
  String get getSelectedCategoryName => selectedCategoryName;
///This is the categoryName while selecting categories to get aya
  setSelectedCategoryName(String name) {
    selectedCategoryName = name;
    notifyListeners();
  }

  String selectedCategoryId = "";
  String get getSelectedCategoryId => selectedCategoryId;
  ///This is the CategoryId while selecting categories to get aya
  setSelectedCategoryId(String id) {
    selectedCategoryId = id;
    notifyListeners();
  }

  int previousCounter = 1;
  int forwardCounter = 1;

  int get getPrevioisCounter=> previousCounter;
  int get getForwardCounter=> forwardCounter;
  
  
  inCrementPreviousCounter() {
    previousCounter++;
    forwardCounter--;
    notifyListeners();
  }

  decrementForwardCounter() {
    previousCounter--;
    forwardCounter++;
    notifyListeners();
  }
  
}