import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import '../../model/disease_model/disease_model.dart';
import '../bloc/group_fields_bloc.dart';
import 'widgets/loading_dialog.dart';
import 'widgets/prescription_card.dart';
import 'widgets/sucsess_screen.dart';

class FormPage extends StatelessWidget {
  const FormPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ListFieldFormBloc(),
      child: Builder(
        builder: (context) {
          final formBloc = context.read<ListFieldFormBloc>();

          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(title: const Text('Reçete Oluşturma')),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                debugPrint("FloatingActionButton pressed");
                formBloc.submit();
              },
              icon: const Icon(Icons.send),
              label: const Text('Gönder'),
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
                padding: const EdgeInsets.all(12.0),
                physics: const ClampingScrollPhysics(),
                child: Column(
                  children: <Widget>[
                    TextFieldBlocBuilder(
                      textFieldBloc: formBloc.diseaseName,
                      decoration: const InputDecoration(
                        labelText: 'Hastalık Adı',
                        prefixIcon: Icon(Icons.title),
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
                    ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      onPressed: formBloc.addPrescription,
                      label: const Text('Reçete Ekle'),
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
          );
        },
      ),
    );
  }
}
