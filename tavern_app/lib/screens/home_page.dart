import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'kayit_screen.dart';
import 'personel_screen.dart';
import 'veresiye_screen.dart';

// Ana sayfa - 4 ekran arasi gecis yapiliyor
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int seciliSayfa = 0; // Hangi sayfa acik

  // 4 ekran liste halinde
  final List<Widget> sayfalar = const [
    DashboardScreen(),
    KayitScreen(),
    PersonelScreen(),
    VeresiyeScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Ust kisimdaki baslik
      appBar: AppBar(
        title: const Text('Taverna App Beta'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      // Sayfa icerigi
      body: sayfalar[seciliSayfa],
      // Alt menü
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: seciliSayfa,
        onTap: (index) {
          setState(() {
            seciliSayfa = index; // Tiklanan sayfayi sec
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Ana Sayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            label: 'Kayıt',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Personel',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label: 'Veresiye',
          ),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
