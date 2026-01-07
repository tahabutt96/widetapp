import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import'package:hive/hive.dart';
part 'add_aya_model.g.dart';
part 'add_aya_model.freezed.dart';
@freezed
class AddAyaModel with _$AddAyaModel{
  
  @HiveType(typeId: 0, adapterName: 'AddAyaAdaptor')
  const factory AddAyaModel({
    @HiveField(0) String? id,
    @HiveField(1) String? catId,
    @HiveField(2) String? aya,
    @HiveField(3) String? date,
    @HiveField(4) int? key,
  })=_AddAyaModel;
  
  factory AddAyaModel.fromJson(Map<String, dynamic> json)=>_$AddAyaModelFromJson(json);
    static String encode(List<AddAyaModel> musics) => json.encode(
        musics
            .map<Map<String, dynamic>>((music) => music.toJson())
            .toList(),
      );

  static List<AddAyaModel> decode(String musics) =>
      (json.decode(musics) as List<dynamic>)
          .map<AddAyaModel>((item) => AddAyaModel.fromJson(item))
          .toList();
  
}