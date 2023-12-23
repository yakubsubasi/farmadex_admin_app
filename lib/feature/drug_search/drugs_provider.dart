import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../model/drug_model/drug_model.dart';

class DrugsProvider extends ChangeNotifier {
  final supabase = Supabase.instance.client;

  List<Drug> drugs = [];

  void searchDrug(String drugName) async {
    final response = await supabase
        .from('ilaclar')
        .select()
        .textSearch('ilac_adi', drugName)
        .limit(20);

    drugs = List.from(
        response.map((e) => Drug.fromJson(e as Map<String, dynamic>)));
    notifyListeners();

    drugs.toString();
  }
}
