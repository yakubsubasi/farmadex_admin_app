import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:form_for_supabase_db/form_page/view/widgets/medicine_card.dart';

import '../../bloc/group_fields_bloc.dart';

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
                      return MedicineCard(
                          index: i,
                          medicineFieldBloc: medicineFieldBloc,
                          prescriptionField: prescriptionField);
                    },
                  );
                }
                return Container();
              },
            ),
            TextButton.icon(
              onPressed: onAddMedicine,
              icon: const Icon(Icons.add),
              label: const Text('İlaç Ekle'),
            ),
            TextFieldBlocBuilder(
              textFieldBloc: prescriptionField.explanation,
              decoration: const InputDecoration(
                  labelText: "Tedavi ile ilgili ek açıklamalar"),
            ),
            CheckboxFieldBlocBuilder(
              booleanFieldBloc: prescriptionField.isIlyasYolbas,
              body: const Text(
                "İlyas Yolbaş Kitabından",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
