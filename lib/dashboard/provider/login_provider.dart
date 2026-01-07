import 'package:appwidgetflutter/dashboard/controllers/firebase_controller.dart';
import 'package:appwidgetflutter/dashboard/error_handling/login_user_state.dart';
import 'package:appwidgetflutter/dashboard/models/user_model.dart';
import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  String message = "";
  bool isLoading = false;
  bool error = false;
  bool success = false;
  Future<LoginUserState> loginUser(UserModel userModel) async {
    isLoading = true;
    error = false;
    message = "";
    success = false;
    notifyListeners();
    LoginUserState response = await FirebaseController.signInUserWitheEmailAndPassword(userModel: userModel);
    if(response.userCredential == null){
      isLoading = false;
      error = true;
      message = response.message!;
      notifyListeners();
    }
    else {
      isLoading = false;
      error = false;
      success = true;
      message = response.message!;
      notifyListeners();
  }
    notifyListeners();
    return response;
  }
}