import '../models/personnel_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// İleride Firebase bağlantısı için Abstract Sınıf (Interface)
abstract class PersonnelRepository {
  Future<List<PersonnelModel>> getPersonnel();
  Future<void> addPersonnel(PersonnelModel personnel);
  Future<void> updatePersonnel(PersonnelModel personnel);
  Future<void> deletePersonnel(String id);
}

// Dummy (Sahte) Veri Sağlayıcı (Firebase kurulana kadar kullanılacak)
class FakePersonnelRepository implements PersonnelRepository {
  final List<PersonnelModel> _mockData = [
    PersonnelModel(id: '1', isim: 'Ahmet Yılmaz', pozisyon: 'Garson', gunlukYevmiye: 500),
    PersonnelModel(id: '2', isim: 'Mehmet Kaya', pozisyon: 'Barmen', gunlukYevmiye: 700),
    PersonnelModel(id: '3', isim: 'Ayşe Demir', pozisyon: 'Aşçı', gunlukYevmiye: 800),
  ];

  @override
  Future<List<PersonnelModel>> getPersonnel() async {
    // 1 saniyelik ağ gecikmesi (network delay) simulasyonu
    await Future.delayed(const Duration(seconds: 1));
    return _mockData;
  }

  @override
  Future<void> addPersonnel(PersonnelModel personnel) async {
    _mockData.add(personnel);
  }

  @override
  Future<void> updatePersonnel(PersonnelModel personnel) async {
    final index = _mockData.indexWhere((element) => element.id == personnel.id);
    if(index != -1) {
      _mockData[index] = personnel;
    }
  }

  @override
  Future<void> deletePersonnel(String id) async {
    _mockData.removeWhere((element) => element.id == id);
  }
}

// Global Repository Provider - İleride bunu FirebaseRepository'e çevireceğiz
final personnelRepositoryProvider = Provider<PersonnelRepository>((ref) {
  return FakePersonnelRepository();
});
