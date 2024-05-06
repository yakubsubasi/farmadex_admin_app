import 'package:farmadex_models/farmadex_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:form_for_supabase_db/feature/form_page/bloc/group_fields_bloc.dart';
import 'package:form_for_supabase_db/feature/form_page/view/form_page_screen.dart';
import 'package:form_for_supabase_db/feature/form_page/view/widgets/loading_dialog.dart';
import 'package:form_for_supabase_db/feature/form_page/view/widgets/prescription_card.dart';
import 'package:form_for_supabase_db/feature/form_page/view/widgets/sucsess_screen.dart';
import 'package:form_for_supabase_db/feature/update_page/bloc/update_fields_bloc.dart';

class UpdatePage extends StatelessWidget {
  final Disease disease;

  const UpdatePage({Key? key, required this.disease}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UpdateFieldFormBloc(disease),
      child: Builder(
        builder: (context) {
          final formBloc = context.read<UpdateFieldFormBloc>();

          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: const Text('Reçete Güncelleme'),
              actions: [
                ElevatedButton.icon(
                  label: const Text('Yeni Hastalık Ekle'),
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const FormPage(),
                    ));
                  },
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                debugPrint("FloatingActionButton pressed");

                formBloc.submit();
              },
              icon: const Icon(Icons.send),
              label: const Text('Güncelle'),
            ),
            body: FormBlocListener<UpdateFieldFormBloc, String, String>(
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
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 700,
                    ),
                    child: Column(
                      children: <Widget>[
                        TextFieldBlocBuilder(
                          textFieldBloc: formBloc.diseaseName,
                          decoration: const InputDecoration(
                            labelText: 'Hastalık Adı',
                            prefixIcon: Icon(Icons.title),
                          ),
                        ),

                        // disease explanation
                        TextFieldBlocBuilder(
                          textFieldBloc: formBloc.diseaseExplanation,
                          decoration: const InputDecoration(
                            labelText: 'Hastalık Açıklaması',
                            prefixIcon: Icon(Icons.description),
                          ),
                        ),

                        //disease short explanation
                        TextFieldBlocBuilder(
                          textFieldBloc: formBloc.diseaseShortDescription,
                          decoration: const InputDecoration(
                            labelText: 'Hastalık Kısa Açıklaması',
                            prefixIcon: Icon(Icons.short_text),
                          ),
                        ),

                        // disease search text
                        TextFieldBlocBuilder(
                          textFieldBloc: formBloc.searchText,
                          decoration: const InputDecoration(
                            labelText: 'Hastalık Arama Metni',
                            prefixIcon: Icon(Icons.search),
                          ),
                        ),

                        // warnings
                        BlocBuilder<ListFieldBloc<TextFieldBloc, dynamic>,
                            ListFieldBlocState<TextFieldBloc, dynamic>>(
                          bloc: formBloc.warnings,
                          builder: (context, state) {
                            if (state.fieldBlocs.isNotEmpty) {
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: state.fieldBlocs.length,
                                itemBuilder: (context, i) {
                                  return Row(
                                    children: [
                                      Expanded(
                                        child: TextFieldBlocBuilder(
                                          textFieldBloc: state.fieldBlocs[i],
                                          decoration: const InputDecoration(
                                            fillColor: Colors.red,
                                            labelText: 'Uyarı',
                                            prefixIcon: Icon(Icons.warning),
                                          ),
                                        ),
                                      ),
                                      if (i != 0)
                                        IconButton(
                                          icon: const Icon(Icons.delete),
                                          onPressed: () => formBloc.warnings
                                              .removeFieldBlocAt(
                                            i,
                                          ),
                                        ),
                                    ],
                                  );
                                },
                              );
                            }
                            return Container();
                          },
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton.icon(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.red.shade100),
                              ),
                              label: const Text('Uyarı Ekle',
                                  style: TextStyle(color: Colors.black)),
                              onPressed: () {
                                formBloc.addWarning();
                              },
                              icon: const Icon(Icons.add)),
                        ),

                        const SizedBox(
                          height: 25,
                        ),

                        BlocBuilder<
                            ListFieldBloc<PrescriptionFieldBloc, dynamic>,
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
              ),
            ),
          );
        },
      ),
    );
  }
}
