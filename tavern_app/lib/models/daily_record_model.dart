// Günlük parasal kayıtları, personel bilgilerini ve devirleri tutan veri modeli
// Bu model aynı zamanda arşive kaydedilecek günlük tutanağın ta kendisidir
class DailyRecordModel {
  final DateTime tarih;
  final double ciro;
  final double bahsis;
  final double giderler;
  final double krediKartiTahsilati;
  
  // Otomatik hesaplanan alanlar
  final double veresiyeToplam;      // Veresiye ekranindan otomatik gelir
  final double personelGideri;      // Yoklamadaki kişi × yevmiye otomatik hesaplanir
  
  // Kasa Takibi
  final double dundenDevreden;
  final double patronAvansi;
  
  // O gun calisan personel ID'leri
  final List<String> calisanIdler;
  
  // Duzenleme izni: sadece ayni hafta icinde duzenleme yapilabilir
  final bool kilitliMi;

  DailyRecordModel({
    DateTime? tarih,
    this.ciro = 0,
    this.bahsis = 0,
    this.giderler = 0,
    this.krediKartiTahsilati = 0,
    this.veresiyeToplam = 0,
    this.personelGideri = 0,
    this.dundenDevreden = 0,
    this.patronAvansi = 0,
    this.calisanIdler = const [],
    this.kilitliMi = false,
  }) : tarih = tarih ?? DateTime.now();

  // Net Kasa Hesabi (formul: Ciro - KrediKarti + Bahsis - Giderler - Veresiye - PersonelGideri)
  double get netKasa => ciro - krediKartiTahsilati + bahsis - giderler - veresiyeToplam - personelGideri;
  
  // Toplam Kasa (formul: Dunden Devreden + Net Kasa - Patron Avansi)
  double get toplamKasa => dundenDevreden + netKasa - patronAvansi;

  // Patrona kalan saf kar (Ciro - tum giderler)
  double get patronaKalan => ciro - giderler - personelGideri - veresiyeToplam;

  DailyRecordModel copyWith({
    DateTime? tarih,
    double? ciro,
    double? bahsis,
    double? giderler,
    double? krediKartiTahsilati,
    double? veresiyeToplam,
    double? personelGideri,
    double? dundenDevreden,
    double? patronAvansi,
    List<String>? calisanIdler,
    bool? kilitliMi,
  }) {
    return DailyRecordModel(
      tarih: tarih ?? this.tarih,
      ciro: ciro ?? this.ciro,
      bahsis: bahsis ?? this.bahsis,
      giderler: giderler ?? this.giderler,
      krediKartiTahsilati: krediKartiTahsilati ?? this.krediKartiTahsilati,
      veresiyeToplam: veresiyeToplam ?? this.veresiyeToplam,
      personelGideri: personelGideri ?? this.personelGideri,
      dundenDevreden: dundenDevreden ?? this.dundenDevreden,
      patronAvansi: patronAvansi ?? this.patronAvansi,
      calisanIdler: calisanIdler ?? this.calisanIdler,
      kilitliMi: kilitliMi ?? this.kilitliMi,
    );
  }
}
