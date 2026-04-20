import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _kullaniciController = TextEditingController();
  final _sifreController = TextEditingController();
  bool _sifreGizli = true;
  bool _hataliGiris = false;

  void _girisYap() {
    final basarili = ref.read(authProvider.notifier).login(
      _kullaniciController.text,
      _sifreController.text,
    );

    if (!basarili) {
      setState(() => _hataliGiris = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kullanıcı adı veya şifre hatalı!'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
    // Basarili giris durumunda main.dart uzerinden HomePage'e yonlendirilecek
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1a237e), Color(0xFF283593), Color(0xFF3949ab)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo / Uygulama Adi
                  const Icon(Icons.local_bar, size: 80, color: Colors.white),
                  const SizedBox(height: 16),
                  const Text(
                    'Taverna App',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'İşletme Yönetim Paneli',
                    style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 16),
                  ),
                  const SizedBox(height: 48),

                  // Giris Formu Karti
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Kullanici Adi
                        TextField(
                          controller: _kullaniciController,
                          decoration: InputDecoration(
                            labelText: 'Kullanıcı Adı',
                            prefixIcon: const Icon(Icons.person_outline),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            errorText: _hataliGiris ? 'Hatalı kullanıcı adı' : null,
                          ),
                          onChanged: (_) => setState(() => _hataliGiris = false),
                        ),
                        const SizedBox(height: 16),

                        // Sifre
                        TextField(
                          controller: _sifreController,
                          obscureText: _sifreGizli,
                          decoration: InputDecoration(
                            labelText: 'Şifre',
                            prefixIcon: const Icon(Icons.lock_outline),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            suffixIcon: IconButton(
                              icon: Icon(_sifreGizli ? Icons.visibility_off : Icons.visibility),
                              onPressed: () => setState(() => _sifreGizli = !_sifreGizli),
                            ),
                            errorText: _hataliGiris ? 'Hatalı şifre' : null,
                          ),
                          onChanged: (_) => setState(() => _hataliGiris = false),
                          onSubmitted: (_) => _girisYap(),
                        ),
                        const SizedBox(height: 24),

                        // Giris Butonu
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _girisYap,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1a237e),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 3,
                            ),
                            child: const Text('GİRİŞ YAP', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1)),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Sifremi Unuttum
                        TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Row(
                                  children: [
                                    Icon(Icons.lock_reset, color: Colors.indigo),
                                    SizedBox(width: 8),
                                    Text('Şifremi Unuttum'),
                                  ],
                                ),
                                content: const Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Şifrenizi sıfırlamak için işletme yöneticinize başvurun.'),
                                    SizedBox(height: 16),
                                    Text('İpucu:', style: TextStyle(fontWeight: FontWeight.bold)),
                                    Text('Varsayılan şifre 4 haneli bir sayıdır.', style: TextStyle(color: Colors.grey)),
                                  ],
                                ),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () => Navigator.pop(ctx),
                                    child: const Text('Anladım'),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: const Text('Şifremi Unuttum', style: TextStyle(color: Colors.indigo)),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  // Demo bilgisi
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Column(
                      children: [
                        Text('Demo Hesaplar', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text('Patron: patron / 1234', style: TextStyle(color: Colors.white60, fontSize: 13)),
                        Text('Admin: admin / 1234', style: TextStyle(color: Colors.white60, fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _kullaniciController.dispose();
    _sifreController.dispose();
    super.dispose();
  }
}
