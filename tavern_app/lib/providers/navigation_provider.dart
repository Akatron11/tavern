import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavigationNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setPage(int index) {
    state = index;
  }
}

// Ana sayfadaki (BottomNavigationBar) seçili sekmenin indeksini tutan provider
final selectedPageIndexProvider = NotifierProvider<NavigationNotifier, int>(() {
  return NavigationNotifier();
});
