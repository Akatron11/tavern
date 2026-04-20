// Kullanici rolleri
enum UserRole {
  patron,
  admin,
  // garson, // Ileride eklenecek
}

// Kullanici veri modeli
class UserModel {
  final String id;
  final String isim;
  final UserRole rol;

  UserModel({
    required this.id,
    required this.isim,
    required this.rol,
  });

  // Rolun Turkce karsiligi
  String get rolAdi {
    switch (rol) {
      case UserRole.patron:
        return 'Patron';
      case UserRole.admin:
        return 'Admin';
    }
  }
}
