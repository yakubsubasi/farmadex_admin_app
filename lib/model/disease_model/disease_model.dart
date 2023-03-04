import 'package:json_annotation/json_annotation.dart';

import 'prescription_model.dart';

part 'disease_model.g.dart';

// to generate command: flutter packages pub run build_runner build --delete-conflicting-outputs

// to watch command: flutter pub run build_runner watch --delete-conflicting-outputs

@JsonSerializable(explicitToJson: true)
class Disease {
  Disease({
    this.id,
    this.name,
    this.specialities,
    this.prescriptions,
  });
  String? id;
  String? name;
  List<Speciality>? specialities;
  List<Prescription>? prescriptions;

  factory Disease.fromJson(Map<String, dynamic> json) =>
      _$DiseaseFromJson(json);

  Map<String, dynamic> toJson() => _$DiseaseToJson(this);
}

@JsonEnum()
enum Speciality {
  internalMedicine,
  pediatric,
  orthopedic,
  cardiology,
  neurology,
  oncology,
  psychiatry,
  generalSurgery,
  gynecology,
  urology,
  emergency,
  ent,
  dental,
  ophtalmology,
  dermatology,
  pulmonaryDisease,
  familyMedicine
}

extension SpecialityExtension on Speciality {
  String get imagepath {
    switch (this) {
      case Speciality.familyMedicine:
        return 'assets/icons/family_medicine.png';

      case Speciality.internalMedicine:
        return 'assets/icons/internal_medicine.png';

      case Speciality.orthopedic:
        return 'assets/icons/orthopedic.png';
      case Speciality.cardiology:
        return 'assets/icons/cardiology.png';
      case Speciality.neurology:
        return 'assets/icons/neurology.png';

      case Speciality.psychiatry:
        return 'assets/icons/psychiatry.png';
      case Speciality.generalSurgery:
        return 'assets/icons/general_surgery.png';

      case Speciality.urology:
        return 'assets/icons/urology.png';
      case Speciality.emergency:
        return 'assets/icons/emergency_medicine.png';
      case Speciality.ent:
        return 'assets/icons/ent.png';
      case Speciality.dental:
        return 'assets/icons/dental.png';
      case Speciality.ophtalmology:
        return 'assets/icons/eye_disease.png';
      case Speciality.pulmonaryDisease:
        return 'assets/icons/pulmonary_disease.png';
      case Speciality.dermatology:
        return 'assets/icons/dermatology.png';
      case Speciality.pediatric:
        return 'assets/icons/pediatric.png';
      case Speciality.gynecology:
        return 'assets/icons/gynecology.png';
      default:
        return 'assets/icons/internal_medicine.png';
    }
  }

  String get valeu {
    switch (this) {
      case Speciality.familyMedicine:
        return 'Aile Hekimliği';
      case Speciality.internalMedicine:
        return 'İç Hastalıkları';
      case Speciality.pediatric:
        return 'Pediatri';
      case Speciality.orthopedic:
        return 'Ortopedi';
      case Speciality.cardiology:
        return 'Kardiyoloji';
      case Speciality.neurology:
        return 'Nöroloji';
      case Speciality.oncology:
        return 'Onkoloji';
      case Speciality.psychiatry:
        return 'Psikiyatri';
      case Speciality.generalSurgery:
        return 'Genel Cerrahi';
      case Speciality.gynecology:
        return 'Jinekoloji';
      case Speciality.urology:
        return 'Üroloji';
      case Speciality.emergency:
        return 'Acil Tıp';
      case Speciality.ent:
        return 'Kulak Burun Boğaz';
      case Speciality.dental:
        return 'Ağız ve Diş Sağlığı';
      case Speciality.ophtalmology:
        return 'Göz Hastalıkları';
      case Speciality.dermatology:
        return 'Dermatoloji';
      case Speciality.pulmonaryDisease:
        return 'Göğüs Hastalıkları';
    }
  }
}
