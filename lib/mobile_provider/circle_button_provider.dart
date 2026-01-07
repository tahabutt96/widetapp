import 'package:appwidgetflutter/dashboard/controllers/firebase_controller.dart';
import 'package:appwidgetflutter/dashboard/error_handling/get_aya_state.dart';
import 'package:flutter/material.dart';

class CircleButtonProvider extends ChangeNotifier {
  int previousCounter = 1;
  int forwardCounter = 1;

  int get getPrevioisCounter=> previousCounter;
  int get getForwardCounter=> forwardCounter;
  
  setCounters() {
    previousCounter = 1;
    forwardCounter = 1;
    notifyListeners();
  }
  setcounterfromFav(int index){
    previousCounter = previousCounter + index;
    forwardCounter = forwardCounter - index;
    notifyListeners();
  }
  inCrementPreviousCounter() {
    previousCounter++;
    forwardCounter--;
    notifyListeners();
  }
  setForwardCounter(String catId) async {
    final GetAllAyaState allAya = await FirebaseController.getAllAyaByCategoryFromFirebase(catId: catId);
    forwardCounter = allAya.result.length;
    notifyListeners();
  }

  decrementForwardCounter() {
    previousCounter--;
    forwardCounter++;
    notifyListeners();
  }
  
  setReverseCounter() {
    previousCounter == 1;
    notifyListeners();
  }

  String aya = "";
  String get getAya => aya;

  setAya(String updatedAya) {
    aya = updatedAya;
    notifyListeners();
  }
}