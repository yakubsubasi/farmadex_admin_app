import 'package:farmadex_models/farmadex_models.dart';
import 'package:form_for_supabase_db/services/supabase_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'disease_controller.g.dart';

@riverpod
class DiseaseController extends _$DiseaseController {
  final supabase = Supabase.instance.client;
  final supaService = SupabaseService();

  @override
  Future<Disease> build(int id) {
    return _fetchDisease(id);
  }

  Future<Disease> updateDisease(Disease disease) async {
    return await supaService.updateDisease(disease);
  }

  Future<Disease> _fetchDisease(int id) async {
    final response = await supabase
        .from('diseases')
        .select('*, prescriptions(*, medicines(*))')
        .eq('id', id)
        .single();

    final diseaseData = Disease.fromJson(response as Map<String, dynamic>);
    return diseaseData;
  }
}
