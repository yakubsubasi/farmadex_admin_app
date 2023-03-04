// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicine_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Medicine _$MedicineFromJson(Map<String, dynamic> json) => Medicine(
      id: json['id'] as String?,
      name: json['name'] as String?,
      activeSubstance: json['activeSubstance'] as String?,
      howOften: json['howOften'] as int?,
      howMany: json['howMany'] as int?,
      howToUse: json['howToUse'] as String?,
      periode: json['periode'] as String?,
      numberOfBoxes: json['numberOfBoxes'] as int?,
      barkod: json['barkod'] as int?,
    );

Map<String, dynamic> _$MedicineToJson(Medicine instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'activeSubstance': instance.activeSubstance,
      'howOften': instance.howOften,
      'howMany': instance.howMany,
      'howToUse': instance.howToUse,
      'periode': instance.periode,
      'barkod': instance.barkod,
      'numberOfBoxes': instance.numberOfBoxes,
    };
