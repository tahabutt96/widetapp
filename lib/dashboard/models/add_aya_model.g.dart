// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_aya_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AddAyaAdaptor extends TypeAdapter<_$_AddAyaModel> {
  @override
  final int typeId = 0;

  @override
  _$_AddAyaModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return _$_AddAyaModel(
      id: fields[0] as String?,
      catId: fields[1] as String?,
      aya: fields[2] as String?,
      date: fields[3] as String?,
      key: fields[4] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, _$_AddAyaModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.catId)
      ..writeByte(2)
      ..write(obj.aya)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.key);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddAyaAdaptor &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_AddAyaModel _$$_AddAyaModelFromJson(Map<String, dynamic> json) =>
    _$_AddAyaModel(
      id: json['id'] as String?,
      catId: json['catId'] as String?,
      aya: json['aya'] as String?,
      date: json['date'] as String?,
      key: json['key'] as int?,
    );

Map<String, dynamic> _$$_AddAyaModelToJson(_$_AddAyaModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'catId': instance.catId,
      'aya': instance.aya,
      'date': instance.date,
      'key': instance.key,
    };
