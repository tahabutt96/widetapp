
import 'package:appwidgetflutter/dashboard/controllers/firebase_controller.dart';
import 'package:appwidgetflutter/dashboard/error_handling/get_category_states.dart';
import 'package:appwidgetflutter/dashboard/models/add_category_model.dart';
import 'package:flutter/material.dart';

class GetAllCategoriesProvider extends ChangeNotifier {
  List<AddCategoryModel> allCategories = [];

  List<AddCategoryModel> get getAllCategories => allCategories;
  bool isLoading = false;
  bool error = true;
  String message = "";
  getAllCategoreisFromDatabase () async {
    isLoading = true;
    error = false;
    message = "";
    final GetAllCategories allCat = await FirebaseController.getAllCategoriesFromFirebase();
     if(allCat.success == false) {
       error = true;
       message = allCat.message;
       isLoading = false;
       notifyListeners();
     }
     else {
      allCategories = allCat.result;
      notifyListeners();
     }
     isLoading = false;
    notifyListeners();
  }

  deleteCategoreisFromDatabase (String catId) async {
    final bool isDeleteCategory = await FirebaseController.deleteCategory(catId);
     if(isDeleteCategory == true) {
      return true;
     }
     else {
      return false;
     }
  }

  String selectedCategory = "Select Category";

  String get getSelectedCategory => selectedCategory;

  setSelectedCategory(String cat) {
    selectedCategory = cat;
    notifyListeners();
  }

  // String uploadSelectedCategory = "Select Category";

  // String get getuploadSelectedCategory => uploadSelectedCategory;

  // setuploadSelectedCategory(String cat) {
  //   uploadSelectedCategory = cat;
  //   notifyListeners();
  // }

  // String selectedCategoryId = "";
  // String get getSelectedCategoryId => selectedCategoryId;

  // setSelectedCategoryId(String catId) {
  //   selectedCategoryId = catId;
  //   notifyListeners();
  // }

  // String uploadSelectedCategoryId = "";
  // String get getuploadSelectedCategoryId => uploadSelectedCategoryId;

  // setuploadSelectedCategoryId(String catId) {
  //   uploadSelectedCategoryId = catId;
  //   notifyListeners();
  // }


  List<String> selectedCategoryForUpload = [];

  List<String> get getselectedCategoryForUpload => selectedCategoryForUpload;

  setselectedCategoryForUpload(String category){
    if(selectedCategoryForUpload.contains(category)){
      selectedCategoryForUpload.remove(category);
    }else{
      selectedCategoryForUpload.add(category);
    }
    notifyListeners();
  }
  List<String> selectedCategoryNameForUpload = [];

  List<String> get getselectedCategoryNameForUpload => selectedCategoryNameForUpload;

  setselectedCategoryNameForUpload(String categoryName){
    if(selectedCategoryForUpload.contains(categoryName)){
      selectedCategoryNameForUpload.remove(categoryName);
    }else{
      selectedCategoryNameForUpload.add(categoryName);
    }
    notifyListeners();
  }
  clearSelectedCategory(){
    selectedCategoryForUpload.clear();
    notifyListeners();
  }

}