import 'package:flutter/material.dart';

// Personel listesi ekrani
class PersonelScreen extends StatelessWidget {
  const PersonelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Simdilik ornek personeller
    // Ileride database'den gelecek
    final List<Map<String, String>> personeller = [
      {'isim': 'Ahmet Yılmaz', 'pozisyon': 'Garson'},
      {'isim': 'Mehmet Kaya', 'pozisyon': 'Barmen'},
      {'isim': 'Ayşe Demir', 'pozisyon': 'Aşçı'},
    ];

    return Column(
      children: [
        // Baslik
        Container(
          padding: const EdgeInsets.all(16),
          child: const Text(
            'Personel Listesi',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        // Personel listesi
        Expanded(
          child: ListView.builder(
            itemCount: personeller.length,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  title: Text(personeller[index]['isim']!),
                  subtitle: Text(personeller[index]['pozisyon']!),
                  trailing: const Icon(Icons.arrow_forward_ios),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
