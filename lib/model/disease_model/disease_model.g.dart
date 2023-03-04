// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'disease_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Disease _$DiseaseFromJson(Map<String, dynamic> json) => Disease(
      id: json['id'] as String?,
      name: json['name'] as String?,
      specialities: (json['specialities'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$SpecialityEnumMap, e))
          .toList(),
      prescriptions: (json['prescriptions'] as List<dynamic>?)
          ?.map((e) => Prescription.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DiseaseToJson(Disease instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'specialities':
          instance.specialities?.map((e) => _$SpecialityEnumMap[e]!).toList(),
      'prescriptions': instance.prescriptions?.map((e) => e.toJson()).toList(),
    };

const _$SpecialityEnumMap = {
  Speciality.internalMedicine: 'internalMedicine',
  Speciality.pediatric: 'pediatric',
  Speciality.orthopedic: 'orthopedic',
  Speciality.cardiology: 'cardiology',
  Speciality.neurology: 'neurology',
  Speciality.oncology: 'oncology',
  Speciality.psychiatry: 'psychiatry',
  Speciality.generalSurgery: 'generalSurgery',
  Speciality.gynecology: 'gynecology',
  Speciality.urology: 'urology',
  Speciality.emergency: 'emergency',
  Speciality.ent: 'ent',
  Speciality.dental: 'dental',
  Speciality.ophtalmology: 'ophtalmology',
  Speciality.dermatology: 'dermatology',
  Speciality.pulmonaryDisease: 'pulmonaryDisease',
  Speciality.familyMedicine: 'familyMedicine',
};
