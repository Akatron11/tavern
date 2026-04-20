import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/daily_record_model.dart';

// Arsivlenmis gunlerin listesini yoneten provider
class HistoryNotifier extends Notifier<List<DailyRecordModel>> {
  @override
  List<DailyRecordModel> build() {
    // 30 gunluk mock veri olustur (Firebase gelene kadar)
    return _generateMockHistory();
  }

  // Yeni bir gunu arsive ekle
  void addRecord(DailyRecordModel record) {
    state = [...state, record.copyWith(kilitliMi: false)];
  }

  // Gecmis kaydi guncelle (duzenleme)
  void updateRecord(int index, DailyRecordModel updatedRecord) {
    final newList = [...state];
    if (index >= 0 && index < newList.length) {
      // Hafta kontrolu: sadece bu hafta icindeki kayitlar duzenlenebilir
      final now = DateTime.now();
      final haftaBasi = now.subtract(Duration(days: now.weekday - 1));
      final kayitTarihi = newList[index].tarih;

      if (kayitTarihi.isAfter(haftaBasi.subtract(const Duration(days: 1)))) {
        newList[index] = updatedRecord;
        state = newList;
      }
    }
  }

  // Belirli bir tarihin kaydinin indeksini bul
  int findByDate(DateTime tarih) {
    return state.indexWhere((r) =>
      r.tarih.year == tarih.year &&
      r.tarih.month == tarih.month &&
      r.tarih.day == tarih.day
    );
  }
}

final historyProvider = NotifierProvider<HistoryNotifier, List<DailyRecordModel>>(() {
  return HistoryNotifier();
});

// Son 7 gunun verisi
final weeklyHistoryProvider = Provider<List<DailyRecordModel>>((ref) {
  final all = ref.watch(historyProvider);
  return all.length >= 7 ? all.sublist(all.length - 7) : all;
});

// Haftalik toplam ciro
final weeklyCiroProvider = Provider<double>((ref) {
  return ref.watch(weeklyHistoryProvider).fold(0.0, (sum, item) => sum + item.ciro);
});

// Haftalik toplam gider (masraflar + personel)
final weeklyGiderProvider = Provider<double>((ref) {
  return ref.watch(weeklyHistoryProvider).fold(0.0, (sum, item) => sum + item.giderler + item.personelGideri);
});

// Haftalik toplam bahsis
final weeklyBahsisProvider = Provider<double>((ref) {
  return ref.watch(weeklyHistoryProvider).fold(0.0, (sum, item) => sum + item.bahsis);
});

// Haftalik toplam personel odemesi
final weeklyPersonelGiderProvider = Provider<double>((ref) {
  return ref.watch(weeklyHistoryProvider).fold(0.0, (sum, item) => sum + item.personelGideri);
});

// Haftalik ortalama net kasa
final weeklyAvgNetProvider = Provider<double>((ref) {
  final list = ref.watch(weeklyHistoryProvider);
  if (list.isEmpty) return 0;
  return list.fold(0.0, (sum, item) => sum + item.netKasa) / list.length;
});

// Aylik toplam ciro
final monthlyCiroProvider = Provider<double>((ref) {
  return ref.watch(historyProvider).fold(0.0, (sum, item) => sum + item.ciro);
});

// Aylik toplam gider (masraflar + personel)
final monthlyGiderProvider = Provider<double>((ref) {
  return ref.watch(historyProvider).fold(0.0, (sum, item) => sum + item.giderler + item.personelGideri);
});

// Aylik toplam bahsis
final monthlyBahsisProvider = Provider<double>((ref) {
  return ref.watch(historyProvider).fold(0.0, (sum, item) => sum + item.bahsis);
});

// Aylik toplam personel odemesi
final monthlyPersonelGiderProvider = Provider<double>((ref) {
  return ref.watch(historyProvider).fold(0.0, (sum, item) => sum + item.personelGideri);
});

// Aylik patrona kalan toplam
final monthlyPatronKalanProvider = Provider<double>((ref) {
  return ref.watch(historyProvider).fold(0.0, (sum, item) => sum + item.patronaKalan);
});

// Aylik en yuksek ciro gunu
final monthlyMaxCiroProvider = Provider<DailyRecordModel?>((ref) {
  final list = ref.watch(historyProvider);
  if (list.isEmpty) return null;
  return list.reduce((a, b) => a.ciro > b.ciro ? a : b);
});

// Aylik en dusuk ciro gunu
final monthlyMinCiroProvider = Provider<DailyRecordModel?>((ref) {
  final list = ref.watch(historyProvider);
  if (list.isEmpty) return null;
  return list.reduce((a, b) => a.ciro < b.ciro ? a : b);
});

// =============================================
// 30 GUNLUK MOCK VERI URETECI
// =============================================
List<DailyRecordModel> _generateMockHistory() {
  final random = Random(42);
  final List<DailyRecordModel> gecmis = [];

  for (int i = 30; i >= 1; i--) {
    final tarih = DateTime.now().subtract(Duration(days: i));
    final ciro = 8000 + random.nextInt(17000).toDouble();
    final gider = 500 + random.nextInt(2500).toDouble();
    final bahsis = 500 + random.nextInt(2000).toDouble();
    final krediKarti = (ciro * 0.4 + random.nextInt(1000)).roundToDouble();
    final veresiye = random.nextInt(2000).toDouble();
    final personelGideri = 1500 + random.nextInt(1500).toDouble();
    final devreden = 2000 + random.nextInt(3000).toDouble();
    final avans = random.nextInt(2000).toDouble();

    gecmis.add(DailyRecordModel(
      tarih: tarih,
      ciro: ciro,
      bahsis: bahsis,
      giderler: gider,
      krediKartiTahsilati: krediKarti,
      veresiyeToplam: veresiye,
      personelGideri: personelGideri,
      dundenDevreden: devreden,
      patronAvansi: avans,
      kilitliMi: i > 7, // 7 gunden eski kayitlar kilitli
    ));
  }

  return gecmis;
}
