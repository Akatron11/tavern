import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'daily_record_provider.dart';

// Net Kasa - artik modeldeki getter'i kullaniyoruz
final netKasaProvider = Provider<double>((ref) {
  return ref.watch(dailyRecordProvider).netKasa;
});

// Toplam Bakiye (Kumulatif Kasa)
final toplamBakiyeProvider = Provider<double>((ref) {
  return ref.watch(dailyRecordProvider).toplamKasa;
});

// Kişi Başı Bahşiş Hesaplayıcı
final kisiBasiBahsisProvider = Provider<double>((ref) {
  final dailyRecord = ref.watch(dailyRecordProvider);
  final calisanSayisi = dailyRecord.calisanIdler.length;
  
  if (calisanSayisi == 0) return 0.0;
  return dailyRecord.bahsis / calisanSayisi;
});

// Patrona kalan kar (bugunun)
final patronaKalanProvider = Provider<double>((ref) {
  return ref.watch(dailyRecordProvider).patronaKalan;
});
