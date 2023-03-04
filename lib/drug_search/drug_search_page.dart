// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:form_for_supabase_db/form_page/bloc/group_fields_bloc.dart';

import 'drugs_provider.dart';

class SearchPage extends StatelessWidget {
  final MedicineFieldBloc medicineFieldBloc;
  const SearchPage({
    Key? key,
    required this.medicineFieldBloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final drugsProvider = context.watch<DrugsProvider>();

    return Scaffold(
        appBar: AppBar(
          title: const Text('İlaç Ara'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(
                  hintText: 'İlaç Adı',
                ),
                onChanged: (value) {
                  drugsProvider.searchDrug(value);
                },
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: drugsProvider.drugs.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                          onTap: () {
                            medicineFieldBloc.medicineName
                                .changeValue(drugsProvider.drugs[index].name);
                            medicineFieldBloc.barkod.changeValue(
                                drugsProvider.drugs[index].barkod.toString());
                            medicineFieldBloc.activeSubstance.changeValue(
                                drugsProvider.drugs[index].activeSubstance);

                            Navigator.pop(context);
                          },
                          title: Text(drugsProvider.drugs[index].name),
                          subtitle:
                              Text(drugsProvider.drugs[index].activeSubstance),
                          trailing:
                              const Icon(Icons.arrow_forward_ios, size: 15.0));
                    }),
              ),
            ],
          ),
        ));
  }
}
