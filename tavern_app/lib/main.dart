import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/login_screen.dart';
import 'screens/home_page.dart';
import 'providers/auth_provider.dart';

// Program buradan basliyor
void main() {
  runApp(const ProviderScope(child: TavernApp()));
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
      home: const AuthGate(), // Giris kontrolu
    );
  }
}

// Giris durumuna gore LoginScreen veya HomePage gosterir
class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);

    // Kullanici giris yapmissa ana sayfayi, yapmamissa login ekranini goster
    if (user != null) {
      return const HomePage();
    } else {
      return const LoginScreen();
    }
  }
}
