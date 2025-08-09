// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:foodexpress/authentification/auth_wrapper.dart';

// ⚠️ Remplacez ces valeurs par vos propres clés Supabase
// Vous les trouverez dans la console Supabase > Settings > API
const SUPABASE_URL = 'https://mjgcllxxrcjpeanntyul.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1qZ2NsbHh4cmNqcGVhbm50eXVsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQ0MDc0MjYsImV4cCI6MjA2OTk4MzQyNn0.7fS6iS5AXCe3LrLVK6HEGYQ0PoFcdR95-d1fnTblSTc';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SUPABASE_URL,
    anonKey: SUPABASE_ANON_KEY,
  );

  runApp(const ProviderScope(child: MyApp()));
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.deepOrange,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // Votre AuthWrapper est maintenant géré directement ici
      home: AuthWrapper(),
    );
  }
}