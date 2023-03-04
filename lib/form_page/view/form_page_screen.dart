import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

import '../../drug_search/drug_search_page.dart';
import '../../model/disease_model/disease_model.dart';
import '../bloc/group_fields_bloc.dart';

class FormPage extends StatelessWidget {
  const FormPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ListFieldFormBloc(),
      child: Builder(
        builder: (context) {
          final formBloc = context.read<ListFieldFormBloc>();

          return Theme(
            data: Theme.of(context).copyWith(
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(title: const Text('Reçete Oluşturma')),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  debugPrint("FloatingActionButton pressed");
                  formBloc.submit();
                },
                child: const Icon(Icons.send),
              ),
              body: FormBlocListener<ListFieldFormBloc, String, String>(
                onSubmitting: (context, state) {
                  LoadingDialog.show(context);
                },
                onSuccess: (context, state) {
                  LoadingDialog.hide(context);

                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const SuccessScreen()));
                },
                onFailure: (context, state) {
                  LoadingDialog.hide(context);

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(state.failureResponse ?? "bir hata oldu")));
                },
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    children: <Widget>[
                      TextFieldBlocBuilder(
                        textFieldBloc: formBloc.diseaseName,
                        decoration: const InputDecoration(
                          labelText: 'Hastalık Adı',
                          prefixIcon: Icon(Icons.sentiment_satisfied),
                        ),
                      ),
                      BlocBuilder<ListFieldBloc<PrescriptionFieldBloc, dynamic>,
                          ListFieldBlocState<PrescriptionFieldBloc, dynamic>>(
                        bloc: formBloc.prescriptions,
                        builder: (context, state) {
                          if (state.fieldBlocs.isNotEmpty) {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: state.fieldBlocs.length,
                              itemBuilder: (context, i) {
                                return PrescriptionCard(
                                  prescriptionIndex: i,
                                  prescriptionField: state.fieldBlocs[i],
                                  onRemovePrescription: () =>
                                      formBloc.removePrescription(i),
                                  onAddMedicine: () =>
                                      formBloc.addMedicineToPrescription(i),
                                );
                              },
                            );
                          }
                          return Container();
                        },
                      ),
                      ElevatedButton(
                        onPressed: formBloc.addPrescription,
                        child: const Text('Reçete Ekle'),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      CheckboxGroupFieldBlocBuilder(
                        multiSelectFieldBloc: formBloc.specialites,
                        itemBuilder: (context, Speciality speciality) =>
                            FieldItem(
                          child: Text(speciality.valeu),
                        ),
                        decoration: const InputDecoration(
                          labelText: 'İlgili Branşlar',
                          prefixIcon: SizedBox(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class PrescriptionCard extends StatelessWidget {
  final int prescriptionIndex;
  final PrescriptionFieldBloc prescriptionField;

  final VoidCallback onRemovePrescription;
  final VoidCallback onAddMedicine;

  const PrescriptionCard({
    Key? key,
    required this.prescriptionIndex,
    required this.prescriptionField,
    required this.onRemovePrescription,
    required this.onAddMedicine,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue[100],
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Reçete #${prescriptionIndex + 1}',
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: onRemovePrescription,
                ),
              ],
            ),
            TextFieldBlocBuilder(
              textFieldBloc: prescriptionField.prescriptionName,
              decoration: const InputDecoration(
                labelText: 'Reçete Başlığı',
              ),
            ),
            TextFieldBlocBuilder(
              textFieldBloc: prescriptionField.shortDescription,
              decoration: const InputDecoration(
                labelText: 'Reçete Kısa açıklaması',
              ),
            ),
            CheckboxFieldBlocBuilder(
              booleanFieldBloc: prescriptionField.isIlyasYolbas,
              body: Container(
                child: Text(
                  "İlyas Yolbaş Kitabından",
                ),
              ),
            ),
            BlocBuilder<ListFieldBloc<MedicineFieldBloc, dynamic>,
                ListFieldBlocState<MedicineFieldBloc, dynamic>>(
              bloc: prescriptionField.medicines,
              builder: (context, state) {
                if (state.fieldBlocs.isNotEmpty) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.fieldBlocs.length,
                    itemBuilder: (context, i) {
                      final medicineFieldBloc = state.fieldBlocs[i];
                      return Card(
                        color: const Color.fromARGB(255, 248, 254, 255),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFieldBlocBuilder(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => SearchPage(
                                              medicineFieldBloc:
                                                  medicineFieldBloc,
                                            ),
                                          ),
                                        );
                                      },
                                      textFieldBloc:
                                          medicineFieldBloc.medicineName,
                                      decoration: InputDecoration(
                                        labelText: 'İlaç #${i + 1}',
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () => prescriptionField.medicines
                                        .removeFieldBlocAt(i),
                                  ),
                                ],
                              ),
                              TextFieldBlocBuilder(
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'barkod',
                                ),
                                textFieldBloc: medicineFieldBloc.barkod,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: TextFieldBlocBuilder(
                                      textAlign: TextAlign.center,
                                      textFieldBloc: medicineFieldBloc.howOften,
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                  const Expanded(
                                      flex: 1, child: Center(child: Text('X'))),
                                  Expanded(
                                    flex: 2,
                                    child: TextFieldBlocBuilder(
                                      textAlign: TextAlign.center,
                                      textFieldBloc: medicineFieldBloc.howMany,
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  SizedBox(
                                    width: 120,
                                    child: TextFieldBlocBuilder(
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.center,
                                        textFieldBloc:
                                            medicineFieldBloc.kutuSayisi,
                                        decoration: const InputDecoration(
                                          labelText: 'Kutu Sayısı',
                                        )),
                                  ),
                                ],
                              ),
                              TextFieldBlocBuilder(
                                textFieldBloc: medicineFieldBloc.howToUse,
                                decoration: const InputDecoration(
                                  labelText: 'Kullanım açıklaması',
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
                return Container();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                  primary: Colors.black, backgroundColor: Colors.white70),
              onPressed: onAddMedicine,
              child: const Text('İlaç Ekle'),
            ),
            TextFieldBlocBuilder(
              textFieldBloc: prescriptionField.explanation,
              decoration: InputDecoration(
                  labelText: "Tedavi ile ilgili ek açıklamalar"),
            )
          ],
        ),
      ),
    );
  }
}

class LoadingDialog extends StatelessWidget {
  static void show(BuildContext context, {Key? key}) => showDialog<void>(
        context: context,
        useRootNavigator: false,
        barrierDismissible: false,
        builder: (_) => LoadingDialog(key: key),
      ).then((_) => FocusScope.of(context).requestFocus(FocusNode()));

  static void hide(BuildContext context) => Navigator.pop(context);

  const LoadingDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Center(
        child: Card(
          child: Container(
            width: 80,
            height: 80,
            padding: const EdgeInsets.all(12.0),
            child: const CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(Icons.tag_faces, size: 100),
            const SizedBox(height: 10),
            const Text(
              'Success',
              style: TextStyle(fontSize: 54, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const FormPage())),
              icon: const Icon(Icons.replay),
              label: const Text('AGAIN'),
            ),
          ],
        ),
      ),
    );
  }
}
