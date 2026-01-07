import 'package:appwidgetflutter/dashboard/models/add_aya_model.dart';

class GetAllAyaState {
  final bool success;
  final String message;
  final List<AddAyaModel> result;
  GetAllAyaState({required this.success, required this.result,this.message=""});
}