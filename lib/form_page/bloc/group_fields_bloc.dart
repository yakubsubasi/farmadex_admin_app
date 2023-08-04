import 'package:farmadex_models/farmadex_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:form_for_supabase_db/services/supabase_service.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class ListFieldFormBloc extends FormBloc<String, String> {
  final diseaseName = TextFieldBloc(name: 'diseaseName', validators: [
    FieldBlocValidators.required,
  ]);

  final supabase = Supabase.instance.client;

  final prescriptions = ListFieldBloc<PrescriptionFieldBloc, dynamic>(
      name: 'prescriptions',
      fieldBlocs: [
        PrescriptionFieldBloc(
          name: 'prescription',
          prescriptionName: TextFieldBloc(name: 'name'),
          shortDescription: TextFieldBloc(name: 'shortDescription'),
          isIlyasYolbas: BooleanFieldBloc(name: 'isIlyasYolbas'),
          explanation: ListFieldBloc(name: 'explanation', fieldBlocs: [
            TextFieldBloc(
                name: 'explanation', validators: [FieldBlocValidators.required])
          ]),
          medicines: ListFieldBloc(name: 'medicines', fieldBlocs: [
            MedicineFieldBloc(
              name: 'medicine',
              medicineName: TextFieldBloc(
                  name: 'medicineName',
                  validators: [FieldBlocValidators.required]),
              activeSubstance: TextFieldBloc(name: 'activeSubstance'),
              howOften: TextFieldBloc(name: 'howOften'),
              howMany: TextFieldBloc(name: 'howMany'),
              kutuSayisi: TextFieldBloc(name: 'kutuSayisi'),
              howToUse: TextFieldBloc(name: 'howToUse'),
              barkod: TextFieldBloc(name: 'barkod'),
            )
          ]),
        )
      ]);

  final specialites = MultiSelectFieldBloc(items: Speciality.values);

  ListFieldFormBloc() {
    addFieldBlocs(
      fieldBlocs: [
        specialites,
        diseaseName,
        prescriptions,
      ],
    );
  }

  void addPrescription() {
    prescriptions.addFieldBloc(PrescriptionFieldBloc(
      name: 'prescription',
      prescriptionName: TextFieldBloc(name: 'name'),
      shortDescription: TextFieldBloc(name: 'shortDescription'),
      medicines: ListFieldBloc(name: 'medicines'),
      isIlyasYolbas: BooleanFieldBloc(name: 'isIlyasYolbas'),
      explanation: ListFieldBloc(name: 'explanation'),
    ));
  }

  void removePrescription(int index) {
    prescriptions.removeFieldBlocAt(index);
  }

  void addMedicineToPrescription(int prescriptionIndex) {
    prescriptions.value[prescriptionIndex].medicines.addFieldBloc(
        MedicineFieldBloc(
            name: 'medicine',
            medicineName: TextFieldBloc(
                name: 'medicineName',
                validators: [FieldBlocValidators.required]),
            activeSubstance: TextFieldBloc(name: 'activeSubstance'),
            howOften: TextFieldBloc(name: 'howOften'),
            howMany: TextFieldBloc(name: 'howMany'),
            kutuSayisi: TextFieldBloc(name: 'kutuSayisi'),
            howToUse: TextFieldBloc(name: 'howToUse'),
            barkod: TextFieldBloc(name: 'numberOfBoxes')));
  }

  void removeMedicineFromPrescription(
      {required int memberIndex, required int hobbyIndex}) {
    prescriptions.value[memberIndex].medicines.removeFieldBlocAt(hobbyIndex);
  }

  void addExplanationToPrescription(int prescriptionIndex) {
    prescriptions.value[prescriptionIndex].explanation.addFieldBloc(
        TextFieldBloc(
            name: 'explanation', validators: [FieldBlocValidators.required]));
  }

  void removeExplanationFromPrescription(
      {required int memberIndex, required int hobbyIndex}) {
    prescriptions.value[memberIndex].explanation.removeFieldBlocAt(hobbyIndex);
  }

  @override
  void onSubmitting() async {
    final disease = Disease(
      name: diseaseName.value,
      specialities: specialites.value,
      prescriptions: prescriptions.value.map<Prescription>((prescriptionField) {
        return Prescription(
            name: prescriptionField.prescriptionName.value,
            shortDescription: prescriptionField.shortDescription.value,
            isIlyasYolbas: prescriptionField.isIlyasYolbas.value,
            explanation: prescriptionField.explanation.value
                .map<String>((explanationField) {
              return explanationField.value;
            }).toList(),
            medicines: prescriptionField.medicines.value
                .map<Medicine>((medicineField) {
              return Medicine(
                  name: medicineField.medicineName.value,
                  activeSubstance: medicineField.activeSubstance.value,
                  howOften: medicineField.howOften.valueToInt,
                  howMany: medicineField.howMany.valueToInt,
                  barkod: medicineField.barkod.valueToInt,
                  howToUse: medicineField.howToUse.value,
                  numberOfBoxes: medicineField.kutuSayisi.valueToInt);
            }).toList());
      }).toList(),
    );

    SupabaseService().addDisease(disease);

    debugPrint(disease.toJson().toString());

    emitSuccess(
        canSubmitAgain: false, successResponse: "Reçete başarıyla eklendi");
  }
}

class PrescriptionFieldBloc extends GroupFieldBloc {
  final BooleanFieldBloc isIlyasYolbas;
  final TextFieldBloc prescriptionName;
  final TextFieldBloc shortDescription;
  final ListFieldBloc<MedicineFieldBloc, dynamic> medicines;
  final ListFieldBloc<TextFieldBloc, dynamic> explanation;

  PrescriptionFieldBloc({
    required this.isIlyasYolbas,
    required this.prescriptionName,
    required this.shortDescription,
    required this.medicines,
    required this.explanation,
    String? name,
  }) : super(name: name, fieldBlocs: [
          prescriptionName,
          shortDescription,
          medicines,
          isIlyasYolbas,
          explanation
        ]);
}

class MedicineFieldBloc extends GroupFieldBloc {
  final TextFieldBloc medicineName;
  final TextFieldBloc activeSubstance;
  final TextFieldBloc howOften;
  final TextFieldBloc howMany;
  final TextFieldBloc kutuSayisi;
  final TextFieldBloc howToUse;
  final TextFieldBloc barkod;

  MedicineFieldBloc({
    required this.medicineName,
    required this.activeSubstance,
    required this.howOften,
    required this.howMany,
    required this.kutuSayisi,
    required this.howToUse,
    required this.barkod,
    String? name,
  }) : super(
          name: name,
          fieldBlocs: [
            medicineName,
            activeSubstance,
            howOften,
            howMany,
            kutuSayisi,
            howToUse,
            barkod
          ],
        );
}
