import 'package:flutter/material.dart';

// Bilgi kutusu (yeniden kullanilabilir widget)
class InfoBox extends StatelessWidget {
  final String baslik;
  final String deger;

  const InfoBox({
    super.key,
    required this.baslik,
    required this.deger,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            baslik,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 5),
          Text(
            deger,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
