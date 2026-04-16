import 'package:flutter/material.dart';
import '../widgets/info_box.dart';

// Dashboard ekrani
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Hosgeldin yazisi
          const Text(
            'Hoşgeldiniz',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          // Bilgi kutulari
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InfoBox(baslik: 'Ciro', deger: '0 TL'),
              const SizedBox(width: 10),
              InfoBox(baslik: 'Kasa', deger: '0 TL'),
            ],
          ),
        ],
      ),
    );
  }
}
