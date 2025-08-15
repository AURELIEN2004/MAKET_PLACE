// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/splash_screen.dart';

// ⚠️ Remplacez ces valeurs par vos propres clés Supabase
// Vous les trouverez dans la console Supabase > Settings > API
const SUPABASE_URL = 'https://xpsvaoouhhhsjgkibwyd.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inhwc3Zhb291aGhoc2pna2lid3lkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTUyNTkwMzAsImV4cCI6MjA3MDgzNTAzMH0.K3J2g2dIj90xLs03u5Aa6ziCJhqykfj5tlCFaLfgcww'; // Remplacez par votre clé anonyme Supabase

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

   await Supabase.initialize(
    url: 'https://xpsvaoouhhhsjgkibwyd.supabase.co', // Remplacez par votre URL Supabase
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inhwc3Zhb291aGhoc2pna2lid3lkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTUyNTkwMzAsImV4cCI6MjA3MDgzNTAzMH0.K3J2g2dIj90xLs03u5Aa6ziCJhqykfj5tlCFaLfgcww', // Remplacez par votre clé anonyme Supabase
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
                visualDensity: VisualDensity.adaptivePlatformDensity,

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // Votre AuthWrapper est maintenant géré directement ici
      home: const SplashScreen(),
    );
  }
}