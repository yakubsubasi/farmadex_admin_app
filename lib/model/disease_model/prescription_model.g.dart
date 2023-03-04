// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prescription_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Prescription _$PrescriptionFromJson(Map<String, dynamic> json) => Prescription(
      id: json['id'] as String?,
      name: json['name'] as String?,
      shortDescription: json['shortDescription'] as String?,
      explanation: json['explanation'] as String?,
      medicines: (json['medicines'] as List<dynamic>?)
          ?.map((e) => Medicine.fromJson(e as Map<String, dynamic>))
          .toList(),
      isIlyasYolbas: json['isIlyasYolbas'] as bool? ?? false,
    );

Map<String, dynamic> _$PrescriptionToJson(Prescription instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'shortDescription': instance.shortDescription,
      'explanation': instance.explanation,
      'isIlyasYolbas': instance.isIlyasYolbas,
      'medicines': instance.medicines?.map((e) => e.toJson()).toList(),
    };
