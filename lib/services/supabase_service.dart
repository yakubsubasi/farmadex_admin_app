import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/disease_model/disease_model.dart';

class SupabaseService {
  final supabase = Supabase.instance.client;

  Future<List<Disease>> getDisease() async {
    final response = await supabase.from('disease').select();
    List<Disease> diseases = List.from(
        response.map((e) => Disease.fromJson(e as Map<String, dynamic>)));

    return diseases;
  }

  Future<void> addDisease(Disease disease) async {
    final diseaseMap = disease.toJson();

    final res = await supabase.from('diseases').insert({
      'name': diseaseMap['name'],
      'specialities': diseaseMap['specialities'],
    }).select();

    for (var prescription in diseaseMap['prescriptions']) {
      final prescRes = await supabase.from('prescriptions').insert({
        'disease_id': res[0]['id'],
        'explanation': prescription['explanation'],
        'name': prescription['name'],
        'is_ilyas_yolbas': prescription['isIlyasYolbas'],
        'short_description': prescription['shortDescription'],
      }).select();

      for (var medicine in prescription['medicines']) {
        await supabase.from('medicines').insert({
          'prescription_id': prescRes[0]['id'],
          'barkod': medicine['barkod'],
          'how_many': medicine['howMany'],
          'how_often': medicine['howOften'],
          'how_to_use': medicine['howToUse'],
          'number_of_boxes': medicine['kutuSayisi'],
        });
      }
    }
  }
}
