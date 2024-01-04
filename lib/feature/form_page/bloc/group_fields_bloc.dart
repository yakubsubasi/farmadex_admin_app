import 'package:farmadex_models/farmadex_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:form_for_supabase_db/services/supabase_service.dart';

class ListFieldFormBloc extends FormBloc<String, String> {
  final diseaseName = TextFieldBloc(name: 'diseaseName', validators: [
    FieldBlocValidators.required,
  ]);

  final diseaseExplanation = TextFieldBloc(name: 'diseaseExplanation');

  final diseaseShortDescription =
      TextFieldBloc(name: 'diseaseShortDescription');

  final warnings = ListFieldBloc<TextFieldBloc, dynamic>(
    name: 'warnings',
    fieldBlocs: [TextFieldBloc(name: 'warning')],
  );

  final searchText = TextFieldBloc(
    name: 'searchText',
  );

  final prescriptions = ListFieldBloc<PrescriptionFieldBloc, dynamic>(
      name: 'prescriptions',
      fieldBlocs: [
        PrescriptionFieldBloc(
          name: 'prescription',
          prescriptionName: TextFieldBloc(name: 'name'),
          shortDescription: TextFieldBloc(name: 'shortDescription'),
          medicines: ListFieldBloc(name: 'medicines', fieldBlocs: [
            MedicineFieldBloc(
              name: 'medicine',
              medicineName: TextFieldBloc(name: 'medicineName'),
              activeSubstance: TextFieldBloc(name: 'activeSubstance'),
              howOften: TextFieldBloc(name: 'howOften'),
              howMany: TextFieldBloc(name: 'howMany'),
              kutuSayisi: TextFieldBloc(name: 'kutuSayisi'),
              howToUse: TextFieldBloc(name: 'howToUse'),
              barkod: TextFieldBloc(name: 'numberOfBoxes'),
            )
          ]),
          explanation: ListFieldBloc(name: 'explanation', fieldBlocs: [
            TextFieldBloc(name: 'explanation'),
          ]),
        )
      ]);

  final specialites = MultiSelectFieldBloc(items: Speciality.values);

  ListFieldFormBloc() {
    addFieldBlocs(
      fieldBlocs: [
        diseaseName,
        diseaseExplanation,
        diseaseShortDescription,
        warnings,
        prescriptions,
        specialites
      ],
    );
  }

  void addWarning() {
    warnings.addFieldBloc(TextFieldBloc(
      name: 'warning',
    ));
  }

  void removeWarning(int index) {
    warnings.removeFieldBlocAt(index);
  }

  void addPrescription() {
    prescriptions.addFieldBloc(PrescriptionFieldBloc(
      name: 'prescription',
      prescriptionName: TextFieldBloc(name: 'name'),
      shortDescription: TextFieldBloc(name: 'shortDescription'),
      medicines: ListFieldBloc(name: 'medicines'),
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
    prescriptions.value[prescriptionIndex].explanation
        .addFieldBloc(TextFieldBloc(name: 'explanation'));
  }

  void removeExplanationFromPrescription(
      {required int memberIndex, required int hobbyIndex}) {
    prescriptions.value[memberIndex].explanation.removeFieldBlocAt(hobbyIndex);
  }

  Disease resultDisease() {
    return Disease(
      name: diseaseName.value,
      explanation: diseaseExplanation.value,
      warnings: warnings.value.map<String>((warningField) {
        return warningField.value;
      }).toList(),
      searchText: searchText.value,
      shortDescription: diseaseShortDescription.value,
      specialities: specialites.value,
      prescriptions: prescriptions.value.map<Prescription>((prescriptionField) {
        return Prescription(
            name: prescriptionField.prescriptionName.value,
            shortDescription: prescriptionField.shortDescription.value,
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
                  howMany: medicineField.howMany.valueToDouble,
                  barkod: medicineField.barkod.valueToInt,
                  howToUse: medicineField.howToUse.value,
                  numberOfBoxes: medicineField.kutuSayisi.valueToInt);
            }).toList());
      }).toList(),
    );
  }

  @override
  void onSubmitting() async {
    final disease = resultDisease();

    try {
      await SupabaseService().addDisease(disease);
      debugPrint(disease.toJson().toString());
      emitSuccess(canSubmitAgain: false);
    } catch (error) {
      emitFailure();
      debugPrint('Error adding disease: $error');
    }
  }
}

class PrescriptionFieldBloc extends GroupFieldBloc {
  final TextFieldBloc prescriptionName;
  final TextFieldBloc shortDescription;
  final ListFieldBloc<MedicineFieldBloc, dynamic> medicines;
  final ListFieldBloc<TextFieldBloc, dynamic> explanation;

  PrescriptionFieldBloc({
    required this.prescriptionName,
    required this.shortDescription,
    required this.medicines,
    required this.explanation,
    String? name,
    Prescription? prescription,
  }) : super(name: name, fieldBlocs: [
          prescriptionName..updateInitialValue(prescription?.name ?? ''),
          shortDescription
            ..updateInitialValue(prescription?.shortDescription ?? ''),
          explanation
            ..addFieldBlocs(prescription?.explanation?.map((explanation) {
                  return TextFieldBloc(initialValue: explanation);
                }).toList() ??
                []),
          medicines
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
    Medicine? medicine,
  }) : super(
          name: name,
          fieldBlocs: [
            medicineName..updateInitialValue(medicine?.name ?? ''),
            activeSubstance
              ..updateInitialValue(medicine?.activeSubstance ?? ''),
            howOften..updateInitialValue(medicine?.howOften.toString() ?? ''),
            howMany..updateInitialValue(medicine?.howMany.toString() ?? ''),
            kutuSayisi
              ..updateInitialValue(medicine?.numberOfBoxes.toString() ?? ''),
            howToUse..updateInitialValue(medicine?.howToUse ?? ''),
            barkod..updateInitialValue(medicine?.barkod.toString() ?? ''),
          ],
        );
}
