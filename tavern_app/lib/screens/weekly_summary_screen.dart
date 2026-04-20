import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/calculator_provider.dart';
import '../providers/daily_record_provider.dart';
import '../providers/history_provider.dart';

class WeeklySummaryScreen extends ConsumerWidget {
  const WeeklySummaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          Container(
            color: Colors.white,
            child: const TabBar(
              labelColor: Colors.indigo,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.indigo,
              indicatorWeight: 3,
              tabs: [
                Tab(icon: Icon(Icons.today), text: 'Günlük'),
                Tab(icon: Icon(Icons.date_range), text: 'Haftalık'),
                Tab(icon: Icon(Icons.calendar_month), text: 'Aylık'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _GunlukTab(),
                _HaftalikTab(),
                _AylikTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================
// GUNLUK TAB
// =============================================
class _GunlukTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final record = ref.watch(dailyRecordProvider);
    final netKasa = ref.watch(netKasaProvider);
    final toplamBakiye = ref.watch(toplamBakiyeProvider);
    final kisiBasiBahsis = ref.watch(kisiBasiBahsisProvider);
    final patronaKalan = ref.watch(patronaKalanProvider);

    return SingleChildScrollView(
      child: Column(
        children: [
          // Ozet Karti
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Colors.blueAccent, Colors.lightBlue]),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [BoxShadow(color: Colors.blue.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 5))],
            ),
            child: Column(
              children: [
                const Text('Günün Hesap Özeti', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _SummaryMetric(label: 'Net Kasa', value: '${netKasa.toStringAsFixed(0)} ₺'),
                    _SummaryMetric(label: 'Toplam Kasa', value: '${toplamBakiye.toStringAsFixed(0)} ₺'),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _SummaryMetric(label: 'Kişi Başı Bahşiş', value: '${kisiBasiBahsis.toStringAsFixed(0)} ₺'),
                    _SummaryMetric(label: 'Patrona Kalan', value: '${patronaKalan.toStringAsFixed(0)} ₺'),
                  ],
                ),
              ],
            ),
          ),

          // Detayli doküm
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.grey[200],
            child: const Text('Detaylı Dökum', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),

          _DetailRow('Ciro', record.ciro, Colors.green),
          _DetailRow('Kredi Kartı Tahsilatı', record.krediKartiTahsilati, Colors.orange, isMinus: true),
          _DetailRow('Bahşiş', record.bahsis, Colors.teal),
          _DetailRow('Giderler', record.giderler, Colors.red, isMinus: true),
          _DetailRow('Veresiye', record.veresiyeToplam, Colors.red, isMinus: true),
          _DetailRow('Personel Gideri', record.personelGideri, Colors.red, isMinus: true),
          const Divider(thickness: 2, indent: 16, endIndent: 16),
          _DetailRow('Dünden Devreden', record.dundenDevreden, Colors.blue),
          _DetailRow('Patron Avansı', record.patronAvansi, Colors.red, isMinus: true),
          
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.indigo.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('TOPLAM KASA', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text('${toplamBakiye.toStringAsFixed(0)} ₺', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.indigo)),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// =============================================
// HAFTALIK TAB
// =============================================
class _HaftalikTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weeklyCiro = ref.watch(weeklyCiroProvider);
    final weeklyGider = ref.watch(weeklyGiderProvider);
    final weeklyBahsis = ref.watch(weeklyBahsisProvider);
    final weeklyAvgNet = ref.watch(weeklyAvgNetProvider);
    final weeklyPersonel = ref.watch(weeklyPersonelGiderProvider);
    final weeklyHistory = ref.watch(weeklyHistoryProvider);

    return SingleChildScrollView(
      child: Column(
        children: [
          // Haftalik Ozet Karti
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Colors.deepPurple, Colors.purpleAccent]),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [BoxShadow(color: Colors.purple.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 5))],
            ),
            child: Column(
              children: [
                const Text('Son 7 Gün Özeti', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _SummaryMetric(label: 'Toplam Ciro', value: '${weeklyCiro.toStringAsFixed(0)} ₺'),
                    _SummaryMetric(label: 'Toplam Gider', value: '${weeklyGider.toStringAsFixed(0)} ₺'),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _SummaryMetric(label: 'Personel Öd.', value: '${weeklyPersonel.toStringAsFixed(0)} ₺'),
                    _SummaryMetric(label: 'Bahşiş Top.', value: '${weeklyBahsis.toStringAsFixed(0)} ₺'),
                  ],
                ),
                const SizedBox(height: 12),
                _SummaryMetric(label: 'Ort. Günlük Net Kasa', value: '${weeklyAvgNet.toStringAsFixed(0)} ₺'),
              ],
            ),
          ),

          // Gunluk Detay
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.grey[200],
            child: const Text('Günlük Dağılım', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: weeklyHistory.length,
            itemBuilder: (context, index) {
              final gun = weeklyHistory[weeklyHistory.length - 1 - index];
              final gunAdi = _gunAdi(gun.tarih.weekday);
              final tarihStr = '${gun.tarih.day.toString().padLeft(2, '0')}.${gun.tarih.month.toString().padLeft(2, '0')}.${gun.tarih.year}';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: ExpansionTile(
                  leading: CircleAvatar(
                    backgroundColor: gun.netKasa > 0 ? Colors.green : Colors.red,
                    child: Text(gunAdi.substring(0, 2), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                  title: Text('$gunAdi - $tarihStr', style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Net: ${gun.netKasa.toStringAsFixed(0)} ₺'),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Column(
                        children: [
                          _MiniDetailRow('Ciro', gun.ciro),
                          _MiniDetailRow('Giderler', gun.giderler),
                          _MiniDetailRow('Personel Gideri', gun.personelGideri),
                          _MiniDetailRow('Bahşiş', gun.bahsis),
                          _MiniDetailRow('Veresiye', gun.veresiyeToplam),
                          _MiniDetailRow('Patrona Kalan', gun.patronaKalan),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// =============================================
// AYLIK TAB (GRAFIK DAHIL)
// =============================================
class _AylikTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final monthlyCiro = ref.watch(monthlyCiroProvider);
    final monthlyGider = ref.watch(monthlyGiderProvider);
    final monthlyBahsis = ref.watch(monthlyBahsisProvider);
    final monthlyPersonel = ref.watch(monthlyPersonelGiderProvider);
    final monthlyPatronKalan = ref.watch(monthlyPatronKalanProvider);
    final maxGun = ref.watch(monthlyMaxCiroProvider);
    final minGun = ref.watch(monthlyMinCiroProvider);
    final allHistory = ref.watch(historyProvider);

    final toplamHarcama = monthlyGider;

    return SingleChildScrollView(
      child: Column(
        children: [
          // Aylik Performans Karti
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF00695c), Color(0xFF26a69a)]),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [BoxShadow(color: Colors.teal.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 5))],
            ),
            child: Column(
              children: [
                const Text('Son 30 Gün Performansı', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _SummaryMetric(label: 'Toplam Ciro', value: '${monthlyCiro.toStringAsFixed(0)} ₺'),
                    _SummaryMetric(label: 'Toplam Masraf', value: '${toplamHarcama.toStringAsFixed(0)} ₺'),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _SummaryMetric(label: 'Personel Öd.', value: '${monthlyPersonel.toStringAsFixed(0)} ₺'),
                    _SummaryMetric(label: 'Bahşiş Top.', value: '${monthlyBahsis.toStringAsFixed(0)} ₺'),
                  ],
                ),
                const Divider(color: Colors.white30, height: 24),
                _SummaryMetric(label: '💰 PATRONA KALAN NET KAR', value: '${monthlyPatronKalan.toStringAsFixed(0)} ₺'),
              ],
            ),
          ),

          // GRAFIK: Giderler vs Patrona Kalan
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.grey[200],
            child: const Text('📊 Aylık Gelir-Gider Grafiği', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),

          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            height: 250,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 8)],
            ),
            child: PieChart(
              PieChartData(
                sectionsSpace: 3,
                centerSpaceRadius: 40,
                sections: [
                  PieChartSectionData(
                    color: Colors.green.shade600,
                    value: monthlyPatronKalan > 0 ? monthlyPatronKalan : 0,
                    title: 'Patron\n${monthlyPatronKalan.toStringAsFixed(0)} ₺',
                    titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                    radius: 70,
                  ),
                  PieChartSectionData(
                    color: Colors.red.shade400,
                    value: toplamHarcama > 0 ? toplamHarcama - monthlyPersonel : 0,
                    title: 'Masraflar\n${(toplamHarcama - monthlyPersonel).toStringAsFixed(0)} ₺',
                    titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                    radius: 65,
                  ),
                  PieChartSectionData(
                    color: Colors.orange.shade400,
                    value: monthlyPersonel > 0 ? monthlyPersonel : 0,
                    title: 'Personel\n${monthlyPersonel.toStringAsFixed(0)} ₺',
                    titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                    radius: 65,
                  ),
                ],
              ),
            ),
          ),

          // Grafik Aciklamasi
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _LegendItem(color: Colors.green.shade600, label: 'Patron'),
                _LegendItem(color: Colors.red.shade400, label: 'Masraflar'),
                _LegendItem(color: Colors.orange.shade400, label: 'Personel'),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // En Yuksek ve En Dusuk Gunler
          if (maxGun != null && minGun != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(child: _RecordCard(title: '📈 En Yüksek', tarih: maxGun.tarih, ciro: maxGun.ciro, color: Colors.green)),
                  const SizedBox(width: 12),
                  Expanded(child: _RecordCard(title: '📉 En Düşük', tarih: minGun.tarih, ciro: minGun.ciro, color: Colors.red)),
                ],
              ),
            ),

          const SizedBox(height: 12),

          // Tum Gunler
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.grey[200],
            child: const Text('Aylık Kayıtlar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: allHistory.length,
            itemBuilder: (context, index) {
              final gun = allHistory[allHistory.length - 1 - index];
              final tarihStr = '${gun.tarih.day.toString().padLeft(2, '0')}.${gun.tarih.month.toString().padLeft(2, '0')}.${gun.tarih.year}';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                child: ListTile(
                  dense: true,
                  leading: Icon(
                    gun.netKasa > 10000 ? Icons.trending_up : Icons.trending_flat,
                    color: gun.netKasa > 10000 ? Colors.green : Colors.orange,
                  ),
                  title: Text(tarihStr, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Ciro: ${gun.ciro.toStringAsFixed(0)} ₺  |  Patron: ${gun.patronaKalan.toStringAsFixed(0)} ₺'),
                  trailing: Text(
                    '${gun.netKasa.toStringAsFixed(0)} ₺',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: gun.netKasa > 10000 ? Colors.green : Colors.orange),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// =============================================
// YARDIMCI WIDGETLAR
// =============================================
class _SummaryMetric extends StatelessWidget {
  final String label;
  final String value;
  const _SummaryMetric({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 14)),
        const SizedBox(height: 5),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  final bool isMinus;
  const _DetailRow(this.label, this.value, this.color, {this.isMinus = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 15)),
          Text(
            '${isMinus ? '-' : '+'}${value.toStringAsFixed(0)} ₺',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }
}

class _MiniDetailRow extends StatelessWidget {
  final String label;
  final double value;
  const _MiniDetailRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 13, color: Colors.grey[700])),
          Text('${value.toStringAsFixed(0)} ₺', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _RecordCard extends StatelessWidget {
  final String title;
  final DateTime tarih;
  final double ciro;
  final Color color;
  const _RecordCard({required this.title, required this.tarih, required this.ciro, required this.color});

  @override
  Widget build(BuildContext context) {
    final tarihStr = '${tarih.day.toString().padLeft(2, '0')}.${tarih.month.toString().padLeft(2, '0')}.${tarih.year}';
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
        boxShadow: [BoxShadow(color: Colors.grey.shade100, blurRadius: 5)],
      ),
      child: Column(
        children: [
          Text(title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 6),
          Text(tarihStr, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          Text('${ciro.toStringAsFixed(0)} ₺', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 14, height: 14, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}

String _gunAdi(int weekday) {
  switch (weekday) {
    case 1: return 'Pazartesi';
    case 2: return 'Salı';
    case 3: return 'Çarşamba';
    case 4: return 'Perşembe';
    case 5: return 'Cuma';
    case 6: return 'Cumartesi';
    case 7: return 'Pazar';
    default: return '';
  }
}
