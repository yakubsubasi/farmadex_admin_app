import 'package:farmadex_models/farmadex_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:form_for_supabase_db/feature/form_page/bloc/group_fields_bloc.dart';
import 'package:form_for_supabase_db/services/supabase_service.dart';

class UpdateFieldFormBloc extends FormBloc<String, String> {
  final diseaseName = TextFieldBloc(name: 'diseaseName', validators: [
    FieldBlocValidators.required,
  ]);

  final diseaseExplanation = TextFieldBloc(name: 'diseaseExplanation');

  final diseaseShortDescription =
      TextFieldBloc(name: 'diseaseShortDescription');

  final warnings = ListFieldBloc<TextFieldBloc, dynamic>(
    name: 'warnings',
  );

  final searchText = TextFieldBloc(
    name: 'searchText',
  );

  final prescriptions = ListFieldBloc<PrescriptionFieldBloc, dynamic>(
    name: 'prescriptions',
  );

  final specialites = MultiSelectFieldBloc(items: Speciality.values);

  final Disease disease;

  UpdateFieldFormBloc(this.disease) {
    addFieldBlocs(
      fieldBlocs: [
        diseaseName..updateInitialValue(disease.name ?? ''),
        diseaseExplanation..updateInitialValue(disease.explanation ?? ''),
        diseaseShortDescription
          ..updateInitialValue(disease.shortDescription ?? ''),
        searchText..updateInitialValue(disease.searchText ?? ''),
        warnings
          ..addFieldBlocs((disease.warnings ?? []).map((warning) {
            return TextFieldBloc(name: 'warning', initialValue: warning);
          }).toList()),
        prescriptions
          ..addFieldBlocs((disease.prescriptions ?? []).map((prescription) {
            final prescriptionFieldBloc = PrescriptionFieldBloc(
              prescription: prescription,
              name: 'prescription',
              prescriptionName: TextFieldBloc(name: 'name'),
              shortDescription: TextFieldBloc(name: 'shortDescription'),
              explanation: ListFieldBloc(name: 'explanation'),
              medicines: ListFieldBloc(
                  name: 'medicines',
                  fieldBlocs: prescription.medicines?.map((medicine) {
                        return MedicineFieldBloc(
                          medicine: medicine,
                          name: 'medicine',
                          medicineName: TextFieldBloc(
                            name: 'medicineName',
                          ),
                          activeSubstance:
                              TextFieldBloc(name: 'activeSubstance'),
                          howOften: TextFieldBloc(name: 'howOften'),
                          howMany: TextFieldBloc(name: 'howMany'),
                          kutuSayisi: TextFieldBloc(name: 'kutuSayisi'),
                          howToUse: TextFieldBloc(name: 'howToUse'),
                          barkod: TextFieldBloc(name: 'barkod'),
                        );
                      }).toList() ??
                      []),
            );
            return prescriptionFieldBloc;
          }).toList()),
        specialites..updateInitialValue(disease.specialities ?? []),
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
    prescriptions.value[prescriptionIndex].medicines
        .addFieldBloc(MedicineFieldBloc(
            name: 'medicine',
            medicineName: TextFieldBloc(
              name: 'medicineName',
            ),
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
        .addFieldBloc(TextFieldBloc(
      name: 'explanation',
    ));
  }

  void removeExplanationFromPrescription(
      {required int memberIndex, required int hobbyIndex}) {
    prescriptions.value[memberIndex].explanation.removeFieldBlocAt(hobbyIndex);
  }

  Disease resultDisease() {
    return Disease(
      id: disease.id,
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
            // id: disease
            //     .prescriptions?[prescriptions.value.indexOf(prescriptionField)]
            //     .id,
            name: prescriptionField.prescriptionName.value,
            shortDescription: prescriptionField.shortDescription.value,
            explanation: prescriptionField.explanation.value
                .map<String>((explanationField) {
              return explanationField.value;
            }).toList(),
            medicines: prescriptionField.medicines.value
                .map<Medicine>((medicineField) {
              return Medicine(
                  // id: disease
                  //     .prescriptions?[
                  //         prescriptions.value.indexOf(prescriptionField)]
                  //     .medicines?[prescriptionField.medicines.value
                  //         .indexOf(medicineField)]
                  //     .id,
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
    debugPrint(disease.toJson().toString());

    try {
      await SupabaseService().updateDisease2(disease);
      emitSuccess(canSubmitAgain: false);
    } catch (e) {
      emitFailure(failureResponse: e.toString());
    }
  }
}
