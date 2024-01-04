import 'package:farmadex_models/farmadex_models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final supabase = Supabase.instance.client;

  Future<List<Disease>> getDisease() async {
    final response = await supabase.from('disease').select();
    List<Disease> diseases = List.from(
        response.map((e) => Disease.fromJson(e as Map<String, dynamic>)));

    return diseases;
  }

  Future<void> deleteDisease(int id) async {
    await supabase.from('diseases').delete().eq('id', id);
  }

  Future<void> updateDisease2(Disease disease) async {
    await supabase.from('diseases').delete().eq('id', disease.id);
    await addDisease(disease);
  }

  Future<Disease> updateDisease(Disease disease) async {
    final diseaseMap = disease.toJson();

    await supabase.from('diseases').update({
      'name': diseaseMap['name'],
      'explanation': diseaseMap['explanation'],
      'short_description': diseaseMap['short_description'],
      'search_text': diseaseMap['search_text'],
      'warnings': diseaseMap['warnings'],
      'specialities': diseaseMap['specialities'],
    }).match({'id': diseaseMap['id']}).select();

    for (var prescription in diseaseMap['prescriptions']) {
      await supabase.from('prescriptions').update({
        'explanation': prescription['explanation'],
        'name': prescription['name'],
        'short_description': prescription['short_description'],
      }).match({'id': prescription['id']}).select();

      for (var medicine in prescription['medicines']) {
        await supabase.from('medicines').update({
          'barkod': medicine['barkod'],
          'name': medicine['name'],
          'active_substance': medicine['active_substance'],
          'how_many': medicine['how_many'],
          'how_often': medicine['how_often'],
          'how_to_use': medicine['how_to_use'],
          'number_of_boxes': medicine['number_of_boxes'],
        }).match({'id': medicine['id'] ?? ''}).select();
      }
    }
    return disease;
  }

  // Other methods...

  Future<void> addDisease(Disease disease) async {
    final diseaseMap = disease.toJson();

    final res = await supabase.from('diseases').insert({
      'name': diseaseMap['name'],
      'explanation': diseaseMap['explanation'],
      'search_text': diseaseMap['search_text'],
      'short_description': diseaseMap['short_description'],
      'warnings': diseaseMap['warnings'],
      'specialities': diseaseMap['specialities'],
    }).select();

    for (var prescription in diseaseMap['prescriptions']) {
      final prescRes = await supabase.from('prescriptions').insert({
        'disease_id': res[0]['id'],
        'explanation': prescription['explanation'],
        'name': prescription['name'],
        'short_description': prescription['short_description'],
      }).select();

      for (var medicine in prescription['medicines']) {
        await supabase.from('medicines').insert({
          'prescription_id': prescRes[0]['id'],
          'barkod': medicine['barkod'],
          'name': medicine['name'],
          'active_substance': medicine['active_substance'],
          'how_many': medicine['how_many'],
          'how_often': medicine['how_often'],
          'how_to_use': medicine['how_to_use'],
          'number_of_boxes': medicine['number_of_boxes'],
        });
      }
    }
  }
}
