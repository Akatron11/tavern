import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/daily_record_provider.dart';
import '../providers/personnel_provider.dart';
import '../providers/veresiye_provider.dart';
import '../providers/history_provider.dart';
import '../models/personnel_model.dart';

class KayitScreen extends ConsumerStatefulWidget {
  const KayitScreen({super.key});

  @override
  ConsumerState<KayitScreen> createState() => _KayitScreenState();
}

class _KayitScreenState extends ConsumerState<KayitScreen> {
  final ciroKutusu = TextEditingController();
  final giderKutusu = TextEditingController();
  final bahsisKutusu = TextEditingController();
  final krediKartiKutusu = TextEditingController();
  final devredenKutusu = TextEditingController();
  final avansKutusu = TextEditingController();

  // Yoklama durumu (personelId -> geldi mi?)
  Map<String, bool> yoklama = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final record = ref.read(dailyRecordProvider);
      _fillControllers(record);
    });
  }

  void _fillControllers(dynamic record) {
    ciroKutusu.text = record.ciro > 0 ? record.ciro.toInt().toString() : '';
    giderKutusu.text = record.giderler > 0 ? record.giderler.toInt().toString() : '';
    bahsisKutusu.text = record.bahsis > 0 ? record.bahsis.toInt().toString() : '';
    krediKartiKutusu.text = record.krediKartiTahsilati > 0 ? record.krediKartiTahsilati.toInt().toString() : '';
    devredenKutusu.text = record.dundenDevreden > 0 ? record.dundenDevreden.toInt().toString() : '';
    avansKutusu.text = record.patronAvansi > 0 ? record.patronAvansi.toInt().toString() : '';
  }

  // Personel maas toplamini hesapla
  double _hesaplaPersonelGideri(List<PersonnelModel> personeller) {
    double toplam = 0;
    for (final person in personeller) {
      if (yoklama[person.id] == true) {
        toplam += person.gunlukYevmiye;
      }
    }
    return toplam;
  }

  // Veresiye toplamini cek
  double _hesaplaVeresiye() {
    final asyncList = ref.read(veresiyeListProvider);
    return asyncList.when(
      data: (list) => list.where((v) => !v.odendiMi).fold(0.0, (sum, v) => sum + v.tutar),
      loading: () => 0.0,
      error: (_, __) => 0.0,
    );
  }

  void _kaydetVeGunuKapat(List<PersonnelModel> personeller) {
    final ciro = double.tryParse(ciroKutusu.text) ?? 0;
    final gider = double.tryParse(giderKutusu.text) ?? 0;
    final bahsis = double.tryParse(bahsisKutusu.text) ?? 0;
    final krediKarti = double.tryParse(krediKartiKutusu.text) ?? 0;
    final devreden = double.tryParse(devredenKutusu.text) ?? 0;
    final avans = double.tryParse(avansKutusu.text) ?? 0;
    final veresiyeToplam = _hesaplaVeresiye();
    final personelGideri = _hesaplaPersonelGideri(personeller);
    final calisanIdler = yoklama.entries.where((e) => e.value).map((e) => e.key).toList();

    // Provider'i guncelle
    final notifier = ref.read(dailyRecordProvider.notifier);
    notifier.updateCiro(ciro);
    notifier.updateGiderler(gider);
    notifier.updateBahsis(bahsis);
    notifier.updateKrediKarti(krediKarti);
    notifier.updateDevreden(devreden);
    notifier.updateAvans(avans);
    notifier.updateVeresiye(veresiyeToplam);
    notifier.updatePersonelGideri(personelGideri);
    notifier.updateCalisanlar(calisanIdler);

    // Arsive kaydet
    final finalRecord = ref.read(dailyRecordProvider);
    ref.read(historyProvider.notifier).addRecord(finalRecord);

    // Ertesi gun icin kasa devri ile sifirla
    notifier.resetGun();

    // Formu temizle
    ciroKutusu.clear();
    giderKutusu.clear();
    bahsisKutusu.clear();
    krediKartiKutusu.clear();
    avansKutusu.clear();
    setState(() { yoklama = {}; });

    // Devreden kasayi guncelle
    devredenKutusu.text = ref.read(dailyRecordProvider).dundenDevreden.toInt().toString();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ Gün başarıyla kapatıldı ve arşive kaydedildi!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final asyncPersonnel = ref.watch(personnelListProvider);
    final veresiyeToplam = _hesaplaVeresiye();

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text('Günlük Kayıt Paneli', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                '${DateTime.now().day.toString().padLeft(2, '0')}.${DateTime.now().month.toString().padLeft(2, '0')}.${DateTime.now().year}',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ),
            const SizedBox(height: 20),

            // ===== MALI VERILER =====
            _buildSectionHeader('💰 Mali Veriler'),
            const SizedBox(height: 8),
            _buildInput(ciroKutusu, 'Tüm Ciro (Nakit + Kart)', Icons.currency_lira),
            _buildInput(krediKartiKutusu, 'Kredi Kartı ile Çekilen', Icons.credit_card),
            _buildInput(bahsisKutusu, 'Toplanan Bahşiş', Icons.volunteer_activism),
            _buildInput(giderKutusu, 'Günlük Giderler (Masraflar)', Icons.trending_down),

            const SizedBox(height: 16),

            // ===== KASA YONETIMI =====
            _buildSectionHeader('🏦 Kasa Yönetimi'),
            const SizedBox(height: 8),
            _buildInput(devredenKutusu, 'Dünden Devreden Kasa', Icons.account_balance),
            _buildInput(avansKutusu, 'Patron Avansı (Kasadan Çekilen)', Icons.trending_down),

            const SizedBox(height: 16),

            // ===== VERESIYE OTOMATIK =====
            _buildSectionHeader('📋 Veresiye (Otomatik)'),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: veresiyeToplam > 0 ? Colors.red.shade50 : Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: veresiyeToplam > 0 ? Colors.red.shade200 : Colors.green.shade200),
              ),
              child: Row(
                children: [
                  Icon(
                    veresiyeToplam > 0 ? Icons.warning_amber : Icons.check_circle,
                    color: veresiyeToplam > 0 ? Colors.red : Colors.green,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      veresiyeToplam > 0
                        ? 'Bekleyen veresiye toplamı: ${veresiyeToplam.toStringAsFixed(0)} ₺'
                        : 'Bekleyen veresiye yok ✓',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: veresiyeToplam > 0 ? Colors.red.shade700 : Colors.green.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Text(
              '  Bu tutar, Veresiye ekranından otomatik çekilir.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),

            const SizedBox(height: 20),

            // ===== PERSONEL YOKLAMA =====
            _buildSectionHeader('👥 Personel Yoklama'),
            const SizedBox(height: 8),
            asyncPersonnel.when(
              data: (personeller) {
                final personelGideri = _hesaplaPersonelGideri(personeller);
                final calisanSayisi = yoklama.values.where((v) => v).length;

                return Column(
                  children: [
                    // Personel Maas Ozeti Karti
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: Colors.indigo.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.indigo.shade200),
                      ),
                      child: Text(
                        'Çalışan: $calisanSayisi kişi  •  Maaş Gideri: ${personelGideri.toStringAsFixed(0)} ₺',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo.shade700),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    // Personel Listesi
                    ...personeller.map((person) {
                      final isChecked = yoklama[person.id] ?? false;
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 3),
                        child: CheckboxListTile(
                          value: isChecked,
                          activeColor: Colors.green,
                          title: Text(person.isim, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('${person.pozisyon} - Yevmiye: ${person.gunlukYevmiye.toStringAsFixed(0)} ₺'),
                          onChanged: (val) {
                            setState(() { yoklama[person.id] = val ?? false; });
                          },
                        ),
                      );
                    }),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Text('Hata: $err'),
            ),

            const SizedBox(height: 24),

            // ===== KAYDET BUTONU =====
            asyncPersonnel.when(
              data: (personeller) => SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save_alt, size: 24),
                  label: const Text('GÜNÜ KAPAT VE KAYDET', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 3,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Günü Kapat'),
                        content: const Text('Bu günün kaydını arşive gönderip yeni güne geçmek istediğinize emin misiniz?\n\nKasa bakiyesi otomatik olarak ertesi güne devredilecektir.'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('İptal')),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                            onPressed: () {
                              Navigator.pop(ctx);
                              _kaydetVeGunuKapat(personeller);
                            },
                            child: const Text('Onayla', style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              loading: () => const SizedBox(),
              error: (_, __) => const SizedBox(),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold));
  }

  Widget _buildInput(TextEditingController controller, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          prefixIcon: Icon(icon),
        ),
      ),
    );
  }

  @override
  void dispose() {
    ciroKutusu.dispose();
    giderKutusu.dispose();
    bahsisKutusu.dispose();
    krediKartiKutusu.dispose();
    devredenKutusu.dispose();
    avansKutusu.dispose();
    super.dispose();
  }
}
