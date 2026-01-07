import 'package:appwidgetflutter/dashboard/controllers/firebase_controller.dart';
import 'package:appwidgetflutter/dashboard/error_handling/add_aya_state.dart';
import 'package:appwidgetflutter/dashboard/models/add_aya_model.dart';
import 'package:flutter/material.dart';

class AddAyaProvider extends ChangeNotifier {
  String message = "";
  bool isLoading = false;
  bool error = false;
  bool success = false;
  Future addAyaToFirebase(AddAyaModel ayaModel) async {
    isLoading = true;
    error = false;
    message = "";
    success = false;
    notifyListeners();
    AddAyaState response = await FirebaseController.addAyaToFirebase(
      addAya: ayaModel,
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
    notifyListeners();
  }
}