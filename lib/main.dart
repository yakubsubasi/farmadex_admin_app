import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_for_supabase_db/consts/supabase_key.dart';
import 'package:form_for_supabase_db/feature/list_all_desease_page/list_disease_view.dart';
import 'package:provider/provider.dart' as provider;
import 'package:supabase_flutter/supabase_flutter.dart';

import 'feature/drug_search/drugs_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Supabase.initialize(
    url: SupabaseConsts.SUPABASE_URL,
    anonKey: SupabaseConsts.ANON_KEY,
  );

  runApp(ProviderScope(
    child: provider.MultiProvider(providers: [
      provider.ChangeNotifierProvider(create: (_) => DrugsProvider()),
    ], child: const MyApp()),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
// hell  s
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowMaterialGrid: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home: const ListDiseaseView(),
    );
  }
}
