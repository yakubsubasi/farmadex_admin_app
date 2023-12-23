import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_for_supabase_db/feature/form_page/view/form_page_screen.dart';
import 'package:form_for_supabase_db/feature/list_all_desease_page/list_disease_controller.dart';
import 'package:form_for_supabase_db/feature/update_page/disease_controller.dart';
import 'package:form_for_supabase_db/feature/update_page/update_page_screen.dart';

class ListDiseaseView extends StatelessWidget {
  const ListDiseaseView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List of Diseases'),
        actions: [
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Yeni ilaç ekle'),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const FormPage(),
              ));
            },
          ),
        ],
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final diseasesAsyncValue = ref.watch(diseaseListControllerProvider);

          return diseasesAsyncValue.when(
            data: (diseases) {
              return ListView.separated(
                itemCount: diseases.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final disease = diseases[index];
                  return Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => UpdatePageGate(
                                disease.id!,
                              ),
                            ));
                          },
                          title: Text(disease.name ?? ''),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Warning'),
                                content: const Text(
                                    'Are you sure you want to delete this disease?'),
                                actions: [
                                  TextButton(
                                    child: const Text('Cancel'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('Delete'),
                                    onPressed: () async {
                                      await ref
                                          .read(diseaseListControllerProvider
                                              .notifier)
                                          .deleteDisease(disease.id!);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Text('Error: $error'),
          );
        },
      ),
    );
  }
}

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
