import 'package:flutter/material.dart';

// Gunluk kayit sayfasi
class KayitScreen extends StatefulWidget {
  const KayitScreen({super.key});

  @override
  State<KayitScreen> createState() => _KayitScreenState();
}

class _KayitScreenState extends State<KayitScreen> {
  // Metin kutulari icin
  final TextEditingController ciroKutusu = TextEditingController();
  final TextEditingController giderKutusu = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            'Günlük Kayıt',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          // Ciro giris yeri
          TextField(
            controller: ciroKutusu,
            decoration: const InputDecoration(
              labelText: 'Ciro',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.attach_money),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 15),
          // Gider giris yeri
          TextField(
            controller: giderKutusu,
            decoration: const InputDecoration(
              labelText: 'Gider',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.money_off),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 20),
          // Kaydet butonu
          ElevatedButton(
            onPressed: () {
              // Simdilik sadece mesaj goster
              // Database ileride eklenecek
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Kayıt başarılı!')),
              );
              // Kutulari temizle
              ciroKutusu.clear();
              giderKutusu.clear();
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            ),
            child: const Text('KAYDET'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    ciroKutusu.dispose();
    giderKutusu.dispose();
    super.dispose();
  }
}
