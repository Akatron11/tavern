import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';

// Firebase gelene kadar kullanilacak sahte kullanici veritabani
final Map<String, Map<String, dynamic>> _sahteKullanicilar = {
  'patron': {
    'sifre': '1234',
    'user': UserModel(id: '1', isim: 'Mekan Sahibi', rol: UserRole.patron),
  },
  'admin': {
    'sifre': '1234',
    'user': UserModel(id: '2', isim: 'Yönetici', rol: UserRole.admin),
  },
};

// Giris yapan kullaniciyi tutan state yoneticisi
class AuthNotifier extends Notifier<UserModel?> {
  @override
  UserModel? build() {
    return null; // Baslangicta kimse giris yapmamis
  }

  // Giris islemi - basarili ise true doner
  bool login(String kullaniciAdi, String sifre) {
    final kullanici = _sahteKullanicilar[kullaniciAdi.toLowerCase()];
    if (kullanici != null && kullanici['sifre'] == sifre) {
      state = kullanici['user'] as UserModel;
      return true;
    }
    return false;
  }

  // Cikis islemi
  void logout() {
    state = null;
  }
}

// Global Auth Provider
final authProvider = NotifierProvider<AuthNotifier, UserModel?>(() {
  return AuthNotifier();
});

// Kullanicinin giris yapip yapmadigini kontrol eden kisa yol
final isLoggedInProvider = Provider<bool>((ref) {
  return ref.watch(authProvider) != null;
});
