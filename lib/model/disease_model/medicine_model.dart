import 'package:json_annotation/json_annotation.dart';

part 'medicine_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Medicine {
  Medicine(
      {this.id,
      this.name,
      this.activeSubstance,
      this.howOften,
      this.howMany,
      this.howToUse,
      this.periode,
      this.numberOfBoxes,
      this.barkod});

  String? id;
  String? name;
  String? activeSubstance;
  int? howOften;
  int? howMany;
  String? howToUse;
  String? periode;
  int? barkod;
  int? numberOfBoxes;

  factory Medicine.fromJson(Map<String, dynamic> json) =>
      _$MedicineFromJson(json);
  Map<String, dynamic> toJson() => _$MedicineToJson(this);
}
