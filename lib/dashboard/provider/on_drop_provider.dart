
import 'package:appwidgetflutter/dashboard/models/drop_file_model.dart';
import 'package:flutter/foundation.dart';

class DropFileProvider extends ChangeNotifier {

  late DroppedFile droppedFile = DroppedFile(url: '', name: '', mime: '', bytes: 0, data: Uint8List(0));
  DroppedFile get getDropFile => droppedFile;

  setDropFile(DroppedFile droppedFile) {
    this.droppedFile = droppedFile;
    notifyListeners();
  }
}

