import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

import '../../../drug_search/drug_search_page.dart';
import '../../bloc/group_fields_bloc.dart';

class MedicineCard extends StatelessWidget {
  const MedicineCard({
    super.key,
    required this.index,
    required this.medicineFieldBloc,
    required this.prescriptionField,
  });

  final int index;
  final MedicineFieldBloc medicineFieldBloc;
  final PrescriptionFieldBloc prescriptionField;

  @override
  Widget build(BuildContext context) {
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
                    textFieldBloc: medicineFieldBloc.medicineName,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => SearchPage(
                                  medicineFieldBloc: medicineFieldBloc,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.search)),
                      labelText: 'İlaç #${index + 1}',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () =>
                      prescriptionField.medicines.removeFieldBlocAt(index),
                ),
              ],
            ),
            TextFieldBlocBuilder(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'etken madde',
              ),
              textFieldBloc: medicineFieldBloc.activeSubstance,
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
                const Expanded(flex: 1, child: Center(child: Text('X'))),
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
                      textFieldBloc: medicineFieldBloc.kutuSayisi,
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
  }
}
