import 'package:appwidgetflutter/dashboard/controllers/firebase_controller.dart';
import 'package:appwidgetflutter/dashboard/error_handling/error_handling_category.dart';
import 'package:appwidgetflutter/dashboard/models/add_category_model.dart';
import 'package:appwidgetflutter/dashboard/models/drop_file_model.dart';
import 'package:flutter/material.dart';

class AddCategoryProvider extends ChangeNotifier {

  String message = "";
  bool isLoading = false;
  bool error = false;
  bool success = false;
  Future addCategoryToFirebase(DroppedFile droppedFile, String name) async {
    isLoading = true;
    error = false;
    message = "";
    success = false;
    notifyListeners();
    final AddCategoryState checkIfCategoryExists = await FirebaseController.
    findCategoryIfAlreadyExistsInFirebase(category: name);
    if (checkIfCategoryExists.success) {
      Future.delayed(Duration(seconds: 3));
      isLoading = false;
      error = true;
      message = checkIfCategoryExists.message;
      notifyListeners();
    } else if (checkIfCategoryExists.success == false) {
      final AddCategoryState result = await FirebaseController.uploadImageToFirebaseForWeb(
        data: droppedFile.data,
        meme: droppedFile.mime,
      );
      if(result.success == false) {
        error = true;
        message = result.message;
        isLoading = false;
        notifyListeners();
      } else if(result.success){
        AddCategoryState response = await FirebaseController.addCategoryToFirebase(
          addCategory: AddCategoryModel(
            id: '', 
            category: name, 
            image: result.message, 
            date: '',
            key: 0,
            )
        );
        if(response.success == false){
          isLoading = false;
          error = true;
          message = response.message;
          notifyListeners();
        }
        else {
          isLoading = false;
          error = false;
          success = true;
          message = response.message;
          notifyListeners();
        }
      }
    }
    notifyListeners();
  }
}