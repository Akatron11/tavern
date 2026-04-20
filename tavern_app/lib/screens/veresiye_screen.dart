import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/veresiye_provider.dart';
import '../models/veresiye_model.dart';
import 'dart:math';

class VeresiyeScreen extends ConsumerWidget {
  const VeresiyeScreen({super.key});

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    final isimController = TextEditingController();
    final tutarController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Yeni Veresiye Ekle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: isimController, decoration: const InputDecoration(labelText: 'Müşteri Adı')),
              TextField(controller: tutarController, decoration: const InputDecoration(labelText: 'Tutar (TL)'), keyboardType: TextInputType.number),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('İptal')),
            ElevatedButton(
              onPressed: () async {
                if (isimController.text.isNotEmpty && tutarController.text.isNotEmpty) {
                  final newItem = VeresiyeModel(
                    id: DateTime.now().millisecondsSinceEpoch.toString() + Random().nextInt(100).toString(),
                    isim: isimController.text,
                    tutar: double.tryParse(tutarController.text) ?? 0,
                  );
                  await ref.read(veresiyeRepoProvider).add(newItem);
                  ref.invalidate(veresiyeListProvider);
                  if (context.mounted) Navigator.pop(context);
                }
              },
              child: const Text('Ekle'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncList = ref.watch(veresiyeListProvider);

    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: const Text('Veresiye Defteri', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          ),
          Expanded(
            child: asyncList.when(
              data: (list) {
                if (list.isEmpty) return const Center(child: Text('Temiz sayfa! Borçlu kimse yok.'));
                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final musteri = list[index];
                    final String formatTarih = '${musteri.eklendigiTarih.day.toString().padLeft(2, '0')}.${musteri.eklendigiTarih.month.toString().padLeft(2, '0')}.${musteri.eklendigiTarih.year}';
                    
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      color: musteri.odendiMi ? Colors.green.shade50 : Colors.white,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: musteri.odendiMi ? Colors.green : Colors.red,
                          child: Icon(musteri.odendiMi ? Icons.check : Icons.account_balance_wallet, color: Colors.white),
                        ),
                        title: Text(
                          musteri.isim, 
                          style: TextStyle(
                            decoration: musteri.odendiMi ? TextDecoration.lineThrough : null,
                            fontWeight: FontWeight.bold
                          )
                        ),
                        subtitle: Text(
                          musteri.odendiMi ? 'Ödendi' : 'Bekleyen Ödeme\nTarih: $formatTarih'
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('${musteri.tutar} ₺', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: musteri.odendiMi ? Colors.green : Colors.red)),
                            IconButton(
                              icon: const Icon(Icons.sync),
                              tooltip: 'Ödendi/Bekleyen Değiştir',
                              onPressed: () async {
                                await ref.read(veresiyeRepoProvider).togglePaid(musteri.id);
                                ref.invalidate(veresiyeListProvider);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Hata: $err')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }
}
