// Personel veri modeli
class PersonnelModel {
  final String id;
  final String isim;
  final String pozisyon;
  final double gunlukYevmiye; // Günlük alacağı ücret

  PersonnelModel({
    required this.id,
    required this.isim,
    required this.pozisyon,
    required this.gunlukYevmiye,
  });

  // Ileride Firebase (Firestore) uzerinden veri okuma/yazma icin JSON donusumleri eklenecek
}
