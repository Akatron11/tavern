import 'package:flutter/material.dart';
import 'screens/home_page.dart';

// Program buradan basliyor
void main() {
  runApp(const TavernApp());
}

// Ana uygulama
class TavernApp extends StatelessWidget {
  const TavernApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taverna App Beta',
      debugShowCheckedModeBanner: false, // Debug yaziyi gizle
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(), // Ilk acilacak sayfa
    );
  }
}
