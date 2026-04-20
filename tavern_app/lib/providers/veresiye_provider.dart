import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/veresiye_model.dart';

// Firebase gelene kadar kullanacagimiz gecici mock repo
class FakeVeresiyeRepository {
  final List<VeresiyeModel> _data = [
    VeresiyeModel(id: '1', isim: 'Hasan Bey', tutar: 2500, odendiMi: false),
    VeresiyeModel(id: '2', isim: 'Ali Bey', tutar: 1000, odendiMi: false),
    VeresiyeModel(id: '3', isim: 'Veli Ağa', tutar: 750, odendiMi: true),
  ];

  Future<List<VeresiyeModel>> getAll() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _data;
  }

  Future<void> add(VeresiyeModel item) async {
    _data.add(item);
  }

  Future<void> togglePaid(String id) async {
    final idx = _data.indexWhere((element) => element.id == id);
    if(idx != -1) {
      _data[idx] = _data[idx].copyWith(odendiMi: !_data[idx].odendiMi);
    }
  }

  Future<void> delete(String id) async {
    _data.removeWhere((element) => element.id == id);
  }
}

final veresiyeRepoProvider = Provider((ref) => FakeVeresiyeRepository());

final veresiyeListProvider = FutureProvider<List<VeresiyeModel>>((ref) async {
  return ref.watch(veresiyeRepoProvider).getAll();
});
