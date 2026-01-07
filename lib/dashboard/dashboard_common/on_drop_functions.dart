
import 'package:appwidgetflutter/dashboard/provider/on_drop_provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:appwidgetflutter/dashboard/models/drop_file_model.dart';
import 'package:provider/provider.dart';

class OnDropFunctions {
  OnDropFunctions._();

  static Future acceptCategoryFile(dynamic event, DropzoneViewController _controller, context)async{
      final name=await _controller.getFilename(event);
      final mime=await _controller.getFileMIME(event);
      final bytes=await _controller.getFileSize(event);
      final url = await _controller.createFileUrl(event);
      final data = await _controller.getFileData(event);
      final droppedFile=DroppedFile(url: url, name: name, mime: mime, bytes: bytes,data: data);
      Provider.of<DropFileProvider>(context, listen: false).setDropFile(droppedFile);
  }
  static Future onButtonPickFiles(DropzoneViewController _controller,) async {
    final files = await _controller.pickFiles(multiple: true);
    return files;
  }
}

class EmptyFunctions {
  EmptyFunctions._();
  static emptyDropFile() {
    return DroppedFile(url: '', name: '', mime: '', bytes: 0, data: Uint8List(0));
  }
}