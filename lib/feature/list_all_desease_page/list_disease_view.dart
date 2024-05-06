import 'package:farmadex_models/farmadex_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_for_supabase_db/feature/list_all_desease_page/list_disease_controller.dart';
import 'package:form_for_supabase_db/feature/update_page/disease_controller.dart';
import 'package:form_for_supabase_db/feature/update_page/update_page_screen.dart';

class ListDiseaseView extends ConsumerWidget {
  const ListDiseaseView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController searchController = TextEditingController();
    final isWideScreen = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      body: Row(
        children: [
          if (isWideScreen)
            Drawer(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        labelText: 'Hastalık ara',
                        suffixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) {
                        ref.watch(searchQueryProvider.notifier).state = value;
                      },
                    ),
                  ),
                  Expanded(
                    child: Consumer(
                      builder: (context, ref, child) {
                        final diseasesAsyncValue =
                            ref.watch(diseaseListControllerProvider);

                        return diseasesAsyncValue.when(
                          data: (diseases) {
                            return DiseasesList();
                          },
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                          error: (error, stackTrace) => Text('Error: $error'),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                final selectedDiseaseId = ref.watch(selectedDiseaseProvider);
                if (selectedDiseaseId != null) {
                  return UpdatePageGate(selectedDiseaseId);
                } else {
                  return const Center(
                      child: Text('Select a disease to update'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DiseasesList extends ConsumerWidget {
  const DiseasesList({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final diseases = ref.watch(searchedDiseaseListProvider);
    return ListView.separated(
      itemCount: diseases.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final disease = diseases[index];
        return ListTile(
          title: Text(disease.name ?? ''),
          trailing: Text(disease.specialities!.first.valeu),
          onTap: () {
            ref.read(selectedDiseaseProvider.notifier).state = disease.id;
          },
        );
      },
    );
  }
}

final selectedDiseaseProvider = StateProvider<int?>((ref) => null);

class UpdatePageGate extends ConsumerWidget {
  final int diseaseId;
  const UpdatePageGate(this.diseaseId, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncDiseaseData = ref.watch(diseaseControllerProvider(diseaseId));
    return Scaffold(
        body: asyncDiseaseData.when(data: (disease) {
      return UpdatePage(
        disease: disease,
      );
    }, loading: () {
      return const Center(child: CircularProgressIndicator());
    }, error: (error, stackTrace) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Error: $error'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return Container(); // return a widget instead of null
    }));
  }
}
