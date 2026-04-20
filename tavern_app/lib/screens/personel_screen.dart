import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/personnel_provider.dart';
import '../repositories/personnel_repository.dart';
import '../models/personnel_model.dart';
import 'dart:math';

// Personel listesi ekrani
class PersonelScreen extends ConsumerWidget {
  const PersonelScreen({super.key});

  // Yeni personel ekleme diyalogu
  void _showAddPersonnelDialog(BuildContext context, WidgetRef ref) {
    final adController = TextEditingController();
    final yevmiyeController = TextEditingController();
    
    String selectedPozisyon = 'Garson';
    final List<String> pozisyonlar = ['Aşçı', 'Garson', 'Ekstracı', 'Bulaşıkçı'];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Yeni Personel Ekle'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(controller: adController, decoration: const InputDecoration(labelText: 'Ad Soyad')),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: selectedPozisyon,
                      items: pozisyonlar.map((String poz) {
                        return DropdownMenuItem(value: poz, child: Text(poz));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => selectedPozisyon = val);
                      },
                      decoration: const InputDecoration(labelText: 'Görevi'),
                    ),
                    const SizedBox(height: 10),
                    TextField(controller: yevmiyeController, decoration: const InputDecoration(labelText: 'Günlük Yevmiye (TL)'), keyboardType: TextInputType.number),
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('İptal')),
                ElevatedButton(
                  onPressed: () async {
                    if (adController.text.isNotEmpty && yevmiyeController.text.isNotEmpty) {
                      final newPerson = PersonnelModel(
                        id: DateTime.now().millisecondsSinceEpoch.toString() + Random().nextInt(100).toString(),
                        isim: adController.text,
                        pozisyon: selectedPozisyon,
                        gunlukYevmiye: double.tryParse(yevmiyeController.text) ?? 0,
                      );
                      
                      // Repository'e ekle
                      await ref.read(personnelRepositoryProvider).addPersonnel(newPerson);
                      // Listeyi guncellemesi icin FutureProvider'i invalidate et
                      ref.invalidate(personnelListProvider);
                      
                      if(context.mounted) Navigator.pop(context);
                    }
                  },
                  child: const Text('Ekle'),
                ),
              ],
            );
          }
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, String personId, String personName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Personeli Sil'),
        content: Text("'$personName' isimli personeli silmek istediğinizden emin misiniz?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('İptal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await ref.read(personnelRepositoryProvider).deletePersonnel(personId);
              ref.invalidate(personnelListProvider);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Sil', style: TextStyle(color: Colors.white)),
          ),
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Riverpod üzerinden personel verisini asenkron olarak dinliyoruz
    final asyncPersonnel = ref.watch(personnelListProvider);

    return Scaffold(
      body: Column(
        children: [
          // Baslik
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: const Text(
              'Personel Yönetimi',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          // Personel listesi Asenkron Durum Yonetimi
          Expanded(
            child: asyncPersonnel.when(
              data: (personeller) {
                 if (personeller.isEmpty) {
                   return const Center(child: Text('Kayıtlı personel bulunamadı. Lütfen sağ alttan ekleyin.'));
                 }
                 return ListView.builder(
                  itemCount: personeller.length,
                  itemBuilder: (context, index) {
                    final person = personeller[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.person),
                        ),
                        title: Text(person.isim),
                        subtitle: Text('${person.pozisyon} - Günlük: ${person.gunlukYevmiye} ₺'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () => _confirmDelete(context, ref, person.id, person.isim),
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Bir hata oluştu: $err')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddPersonnelDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }
}
