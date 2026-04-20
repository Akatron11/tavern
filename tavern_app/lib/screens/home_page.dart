import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'kayit_screen.dart';
import 'personel_screen.dart';
import 'veresiye_screen.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/navigation_provider.dart';
import '../providers/auth_provider.dart';
import 'weekly_summary_screen.dart';

// Ana sayfa - 5 ekran arasi gecis yapiliyor
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  // 5 ekran liste halinde sabit olarak tutulabilir
  final List<Widget> sayfalar = const [
    DashboardScreen(),
    WeeklySummaryScreen(),
    KayitScreen(),
    PersonelScreen(),
    VeresiyeScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Riverpod uzerinden secili sayfayi dinliyoruz
    final int seciliSayfa = ref.watch(selectedPageIndexProvider);
    final user = ref.watch(authProvider);

    return Scaffold(
      // Ust kisimdaki baslik
      appBar: AppBar(
        title: const Text('Taverna App Beta'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          // Giris yapan kullanici bilgisi
          if (user != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${user.isim} (${user.rolAdi})',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Çıkış Yap',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Çıkış Yap'),
                    content: const Text('Uygulamadan çıkmak istediğinize emin misiniz?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('İptal')),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        onPressed: () {
                          Navigator.pop(ctx);
                          ref.read(authProvider.notifier).logout();
                        },
                        child: const Text('Çıkış Yap', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ],
      ),
      // Sayfa icerigi
      body: sayfalar[seciliSayfa],
      // Alt menü
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: seciliSayfa,
        onTap: (index) {
          // Secili sayfayi guncelle
          ref.read(selectedPageIndexProvider.notifier).setPage(index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Ana Sayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Özet',
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
        type: BottomNavigationBarType.fixed, // 4 ten fazla oge olunca buglamamasi icin eklendi
      ),
    );
  }
}
