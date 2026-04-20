import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/calculator_provider.dart';
import '../providers/daily_record_provider.dart';
import '../providers/history_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  void _showEditDialog(BuildContext context, WidgetRef ref, String title, bool isAvans) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Tutar (₺)'),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('İptal')),
            ElevatedButton(
              onPressed: () {
                final val = double.tryParse(controller.text) ?? 0;
                if (isAvans) {
                  ref.read(dailyRecordProvider.notifier).updateAvans(val);
                } else {
                  ref.read(dailyRecordProvider.notifier).updateDevreden(val);
                }
                if (context.mounted) Navigator.pop(context);
              },
              child: const Text('Kaydet'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final toplamBakiye = ref.watch(toplamBakiyeProvider);
    final dailyRecord = ref.watch(dailyRecordProvider);
    final bugunNet = ref.watch(netKasaProvider);
    final history = ref.watch(historyProvider);

    // Son 5 gecmis kayit (en yeni ustte)
    final sonKayitlar = history.length > 5 ? history.sublist(history.length - 5) : history;

    return SingleChildScrollView(
      child: Column(
        children: [
          // Ana Bakiye Karti
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Colors.indigo, Colors.blue]),
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [BoxShadow(color: Colors.black26, offset: Offset(0, 4), blurRadius: 10)],
            ),
            child: Column(
              children: [
                const Text('GÜNCEL TOPLAM KASA', style: TextStyle(color: Colors.white70, fontSize: 16)),
                const SizedBox(height: 10),
                Text('${toplamBakiye.toStringAsFixed(0)} ₺', style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
              ],
            ),
          ),

          // Alt Metrikler (Dunden Devreden ve Avans)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: _MiniCard(
                    title: 'Dünden Devreden',
                    value: dailyRecord.dundenDevreden,
                    color: Colors.green,
                    icon: Icons.account_balance,
                    onTap: () => _showEditDialog(context, ref, 'Dünden Devreden Kasa', false),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _MiniCard(
                    title: 'Patron Avansı',
                    value: dailyRecord.patronAvansi,
                    color: Colors.redAccent,
                    icon: Icons.trending_down,
                    onTap: () => _showEditDialog(context, ref, 'Kasadan Çekilen Avans', true),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Gecmis islem gecmisi
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            alignment: Alignment.centerLeft,
            child: const Text('Son İşlemler (Tarihçe)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),

          // Bugunun neti
          ListTile(
            leading: const CircleAvatar(backgroundColor: Colors.blueAccent, child: Icon(Icons.today, color: Colors.white)),
            title: const Text('Bugünün Net Kasası', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Canlı hesaplanan'),
            trailing: Text(
              '${bugunNet >= 0 ? '+' : ''}${bugunNet.toStringAsFixed(0)} ₺',
              style: TextStyle(color: bugunNet >= 0 ? Colors.green : Colors.red, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),

          // Gecmis gunler
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: sonKayitlar.length,
            itemBuilder: (context, index) {
              final gun = sonKayitlar[sonKayitlar.length - 1 - index];
              final tarihStr = '${gun.tarih.day.toString().padLeft(2, '0')}.${gun.tarih.month.toString().padLeft(2, '0')}.${gun.tarih.year}';
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: gun.kilitliMi ? Colors.grey : Colors.teal,
                  child: Icon(gun.kilitliMi ? Icons.lock : Icons.history, color: Colors.white, size: 18),
                ),
                title: Text('$tarihStr - Net: ${gun.netKasa.toStringAsFixed(0)} ₺', style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Ciro: ${gun.ciro.toStringAsFixed(0)} ₺  |  Kasa: ${gun.toplamKasa.toStringAsFixed(0)} ₺'),
                trailing: gun.kilitliMi
                    ? const Icon(Icons.lock_outline, color: Colors.grey, size: 18)
                    : IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        tooltip: 'Düzenle',
                        onPressed: () => _showEditRecordDialog(context, ref, gun, history.indexOf(gun)),
                      ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Gecmis kaydi duzenleme diyalogu
  void _showEditRecordDialog(BuildContext context, WidgetRef ref, dynamic record, int index) {
    final ciroC = TextEditingController(text: record.ciro.toInt().toString());
    final giderC = TextEditingController(text: record.giderler.toInt().toString());
    final bahsisC = TextEditingController(text: record.bahsis.toInt().toString());
    final krediC = TextEditingController(text: record.krediKartiTahsilati.toInt().toString());

    showDialog(
      context: context,
      builder: (context) {
        final tarihStr = '${record.tarih.day.toString().padLeft(2, '0')}.${record.tarih.month.toString().padLeft(2, '0')}.${record.tarih.year}';
        return AlertDialog(
          title: Text('Kayıt Düzenle - $tarihStr'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('⚠️ Bu haftanın kaydını düzenliyorsunuz', style: TextStyle(color: Colors.orange, fontSize: 12)),
                const SizedBox(height: 12),
                TextField(controller: ciroC, decoration: const InputDecoration(labelText: 'Ciro'), keyboardType: TextInputType.number),
                TextField(controller: giderC, decoration: const InputDecoration(labelText: 'Giderler'), keyboardType: TextInputType.number),
                TextField(controller: bahsisC, decoration: const InputDecoration(labelText: 'Bahşiş'), keyboardType: TextInputType.number),
                TextField(controller: krediC, decoration: const InputDecoration(labelText: 'Kredi Kartı'), keyboardType: TextInputType.number),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('İptal')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
              onPressed: () {
                final updated = record.copyWith(
                  ciro: double.tryParse(ciroC.text) ?? record.ciro,
                  giderler: double.tryParse(giderC.text) ?? record.giderler,
                  bahsis: double.tryParse(bahsisC.text) ?? record.bahsis,
                  krediKartiTahsilati: double.tryParse(krediC.text) ?? record.krediKartiTahsilati,
                );
                ref.read(historyProvider.notifier).updateRecord(index, updated);
                if (context.mounted) Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('✅ Kayıt güncellendi!'), backgroundColor: Colors.green),
                );
              },
              child: const Text('Güncelle', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}

class _MiniCard extends StatelessWidget {
  final String title;
  final double value;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  const _MiniCard({required this.title, required this.value, required this.color, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [BoxShadow(color: Colors.grey.shade100, blurRadius: 5)],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 8),
            Text(title, style: TextStyle(color: Colors.grey.shade600, fontSize: 13), textAlign: TextAlign.center),
            const SizedBox(height: 4),
            Text('${value.toStringAsFixed(0)} ₺', style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
