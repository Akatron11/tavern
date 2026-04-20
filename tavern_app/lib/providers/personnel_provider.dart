import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/personnel_model.dart';
import '../repositories/personnel_repository.dart';

// Personel listesini asenkron olarak (Future) çekip tutan provider
final personnelListProvider = FutureProvider<List<PersonnelModel>>((ref) async {
  final repository = ref.watch(personnelRepositoryProvider);
  return repository.getPersonnel();
});

// Personel Yoklama (Devamlılık) durumunu tutan Provider (Personel ID -> Geldi mi?)
class AttendanceNotifier extends Notifier<Map<String, bool>> {
  @override
  Map<String, bool> build() {
    return {};
  }

  void toggleAttendance(String personnelId, bool isPresent) {
    final newState = Map<String, bool>.from(state);
    newState[personnelId] = isPresent;
    state = newState;
  }
}

// Devamlılık durumunu ağacın her yerinden erişilebilir yapan provider
final attendanceProvider = NotifierProvider<AttendanceNotifier, Map<String, bool>>(() {
  return AttendanceNotifier();
});
