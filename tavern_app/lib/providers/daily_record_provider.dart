import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/daily_record_model.dart';

// Bugunku kaydi yoneten provider
class DailyRecordNotifier extends Notifier<DailyRecordModel> {
  @override
  DailyRecordModel build() {
    return DailyRecordModel(tarih: DateTime.now());
  }

  void updateCiro(double value) => state = state.copyWith(ciro: value);
  void updateBahsis(double value) => state = state.copyWith(bahsis: value);
  void updateGiderler(double value) => state = state.copyWith(giderler: value);
  void updateKrediKarti(double value) => state = state.copyWith(krediKartiTahsilati: value);
  void updateVeresiye(double value) => state = state.copyWith(veresiyeToplam: value);
  void updatePersonelGideri(double value) => state = state.copyWith(personelGideri: value);
  void updateDevreden(double value) => state = state.copyWith(dundenDevreden: value);
  void updateAvans(double value) => state = state.copyWith(patronAvansi: value);
  void updateCalisanlar(List<String> idler) => state = state.copyWith(calisanIdler: idler);

  // Gunu temizle (arsive kaydettikten sonra)
  void resetGun() {
    final eskiToplamKasa = state.toplamKasa;
    state = DailyRecordModel(
      tarih: DateTime.now(),
      dundenDevreden: eskiToplamKasa, // Onceki gunun kasasi devir olarak aktarilir
    );
  }

  // Gecmis kaydi duzenleme icin yukle
  void loadRecord(DailyRecordModel record) {
    state = record;
  }
}

final dailyRecordProvider = NotifierProvider<DailyRecordNotifier, DailyRecordModel>(() {
  return DailyRecordNotifier();
});
