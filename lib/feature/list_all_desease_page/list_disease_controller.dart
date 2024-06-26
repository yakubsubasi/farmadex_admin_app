import 'package:farmadex_models/farmadex_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'list_disease_controller.g.dart';

@riverpod
class DiseaseListController extends _$DiseaseListController {
  @override
  FutureOr<List<Disease>> build() {
    return _fetchDiseases();
  }

  Future<void> deleteDisease(int id) async {
    final supabase = Supabase.instance.client;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await supabase.from('diseases').delete().eq('id', id);
      return _fetchDiseases();
    });
  }

  FutureOr<List<Disease>> _fetchDiseases() async {
    final supabase = Supabase.instance.client;

    final response = await supabase.from('diseases').select();

    List<Disease> diseases = List.from(
        response.map((e) => Disease.fromJson(e as Map<String, dynamic>)));

    return diseases;
  }
}

final searchQueryProvider = StateProvider<String>(
  (ref) => '',
);

@riverpod
List<Disease> searchedDiseaseList(SearchedDiseaseListRef ref) {
  final query = ref.watch(searchQueryProvider);
  final list = ref.watch(diseaseListControllerProvider).requireValue;

  return query == ''
      ? list
      : list.where((element) {
          return element.searchText!
              .toLowerCase()
              .contains(query.toLowerCase());
        }).toList();
}
