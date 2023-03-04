import 'package:flutter/material.dart';
import 'package:form_for_supabase_db/consts/supabase_key.dart';
import 'package:form_for_supabase_db/drug_search/drug_search_page.dart';
import 'package:form_for_supabase_db/form_page/view/form_page_screen.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'drug_search/drugs_provider.dart';

void main() {
  // add supabase

  WidgetsFlutterBinding.ensureInitialized();

  Supabase.initialize(
    url: SupabaseConsts.SUPABASE_URL,
    anonKey: SupabaseConsts.ANON_KEY,
  );

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => DrugsProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
// hell  s
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FormPage(),
    );
  }
}
