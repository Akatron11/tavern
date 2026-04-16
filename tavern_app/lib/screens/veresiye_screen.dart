import 'package:flutter/material.dart';

// Veresiye musteriler ekrani
class VeresiyeScreen extends StatelessWidget {
  const VeresiyeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Simdilik ornek musteri borclari
    // Ileride database'den gelecek
    final List<Map<String, dynamic>> borcluMusteriler = [
      {'isim': 'Hasan Bey', 'tutar': '2500 TL', 'durum': 'Ödenmedi'},
      {'isim': 'Ali Bey', 'tutar': '1000 TL', 'durum': 'Bekliyor'},
      {'isim': 'Veli Ağa', 'tutar': '750 TL', 'durum': 'Ödenmedi'},
    ];

    return Column(
      children: [
        // Baslik
        Container(
          padding: const EdgeInsets.all(16),
          child: const Text(
            'Veresiye Müşteriler',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        // Musteri listesi
        Expanded(
          child: ListView.builder(
            itemCount: borcluMusteriler.length,
            itemBuilder: (context, index) {
              final musteri = borcluMusteriler[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.red,
                    child: Icon(Icons.credit_card, color: Colors.white),
                  ),
                  title: Text(musteri['isim']!),
                  subtitle: Text(musteri['durum']!),
                  trailing: Text(
                    musteri['tutar']!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
