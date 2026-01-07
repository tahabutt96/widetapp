
import 'dart:io';

class InternetCheck {
  static bool isConnected = false;
  static List resultsFromWhatsaApp = [];
  static checkingInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isConnected = true;
      }
    } on SocketException catch (_) {
      isConnected = false;
    }
  }
}