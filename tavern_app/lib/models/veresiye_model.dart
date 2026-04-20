class VeresiyeModel {
  final String id;
  final String isim;
  final double tutar;
  final bool odendiMi;
  final DateTime eklendigiTarih;

  VeresiyeModel({
    required this.id,
    required this.isim,
    required this.tutar,
    this.odendiMi = false,
    DateTime? eklendigiTarih,
  }) : eklendigiTarih = eklendigiTarih ?? DateTime.now();

  VeresiyeModel copyWith({bool? odendiMi, DateTime? eklendigiTarih}) {
    return VeresiyeModel(
      id: this.id,
      isim: this.isim,
      tutar: this.tutar,
      odendiMi: odendiMi ?? this.odendiMi,
      eklendigiTarih: eklendigiTarih ?? this.eklendigiTarih,
    );
  }
}
