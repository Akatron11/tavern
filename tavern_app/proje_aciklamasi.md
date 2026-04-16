# Tavern App - Detaylı Proje Açıklaması

## 📋 Proje Hakkında

**Tavern App**, taverna işletmeleri için geliştirilmiş basit bir mobil muhasebe uygulamasıdır. 

### Temel Özellikler:
- Günlük ciro ve gider kaydı
- Personel listesi görüntüleme
- Veresiye müşteri takibi
- Dashboard ile özet bilgiler

---

## 📁 Dosya Dizini Yapısı

```
tavern_app/
│
├── android/              # Android platformu için gerekli dosyalar
├── windows/              # Windows platformu için gerekli dosyalar
│
├── lib/                  # UYGULAMANIN KAYNAK KODLARI (EN ÖNEMLİ)
│   ├── main.dart         # Uygulamanın başlangıç noktası
│   │
│   ├── screens/          # Tüm ekranlar bu klasörde
│   │   ├── home_page.dart          # Ana sayfa (navigation bar ile)
│   │   ├── dashboard_screen.dart   # Dashboard ekranı
│   │   ├── kayit_screen.dart       # Kayıt formu ekranı
│   │   ├── personel_screen.dart    # Personel listesi
│   │   └── veresiye_screen.dart    # Veresiye listesi
│   │
│   └── widgets/          # Tekrar kullanılabilir bileşenler
│       └── info_box.dart           # Bilgi kutusu widget'ı
│
├── pubspec.yaml          # Proje ayarları ve bağımlılıklar
├── pubspec.lock          # Paket versiyonlarının kilidi
│
├── README.md             # Proje hakkında genel bilgi
├── NOTES.md              # Geliştirme notları
├── NASIL_CALISTIRILIR.md # Çalıştırma rehberi
│
├── .gitignore            # Git için yok sayılacak dosyalar
└── .metadata             # Flutter metadata
```

---

## 📚 DOSYALARIN DETAYLI AÇIKLAMASI

### 1. **main.dart** - Uygulamanın Başlangıcı

**Tam Kod:**
```dart
import 'package:flutter/material.dart';
import 'screens/home_page.dart';

// Program buradan basliyor
void main() {
  runApp(const TavernApp());
}

// Ana uygulama
class TavernApp extends StatelessWidget {
  const TavernApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taverna App Beta',
      debugShowCheckedModeBanner: false, // Debug yaziyi gizle
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(), // Ilk acilacak sayfa
    );
  }
}
```

**Satır Satır Açıklama:**

- **Satır 1-2:** Import'lar
  - `material.dart`: Flutter'ın temel UI bileşenlerini getirir
  - `home_page.dart`: Bizim yazdığımız ana sayfa dosyası

- **Satır 5-7:** `main()` fonksiyonu
  - Uygulama **BURADAN** başlar (entry point)
  - `runApp()` uygulamayı çalıştırır
  - `TavernApp()` widget'ını ekrana koyar

- **Satır 10:** `class TavernApp extends StatelessWidget`
  - `StatelessWidget` → Değişmeyen bir widget
  - Uygulama çalıştığı sürece değişmeyecek

- **Satır 14-25:** `build()` metodu
  - Ne gösterileceğini belirler
  - `MaterialApp` → Uygulamanın ana container'ı
  - `title` → Uygulama başlığı
  - `debugShowCheckedModeBanner: false` → Sağ üstteki "DEBUG" yazısını kaldırır
  - `theme` → Renk ve tema ayarları (mavi tonları)
  - `home` → İlk açılacak sayfa (HomePage)

---

### 2. **home_page.dart** - Ana Sayfa ve Navigasyon

**Tam Kod:**
```dart
import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'kayit_screen.dart';
import 'personel_screen.dart';
import 'veresiye_screen.dart';

// Ana sayfa - 4 ekran arasi gecis yapiliyor
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int seciliSayfa = 0; // Hangi sayfa acik

  // 4 ekran liste halinde
  final List<Widget> sayfalar = const [
    DashboardScreen(),
    KayitScreen(),
    PersonelScreen(),
    VeresiyeScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Ust kisimdaki baslik
      appBar: AppBar(
        title: const Text('Taverna App Beta'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      // Sayfa icerigi
      body: sayfalar[seciliSayfa],
      // Alt menü
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: seciliSayfa,
        onTap: (index) {
          setState(() {
            seciliSayfa = index; // Tiklanan sayfayi sec
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Ana Sayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            label: 'Kayıt',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Personel',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label: 'Veresiye',
          ),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
```

**Satır Satır Açıklama:**

- **Satır 2-5:** Tüm ekranları import et

- **Satır 8:** `StatefulWidget` → Değişebilen widget
  - Sayfa geçişleri için state tutmamız gerekiyor

- **Satır 16:** `seciliSayfa` değişkeni
  - Hangi sayfa seçili? (0, 1, 2, 3)
  - 0 = Dashboard, 1 = Kayıt, 2 = Personel, 3 = Veresiye

- **Satır 19-24:** `sayfalar` listesi
  - 4 ekranı liste olarak tutar
  - `final` → Değiştirilemez
  - `const` → Sabittir

- **Satır 28:** `Scaffold` → Her sayfa için temel iskelet
  - AppBar (üst çubuk)
  - Body (ana içerik)
  - BottomNavigationBar (alt menü)

- **Satır 35:** `body: sayfalar[seciliSayfa]`
  - Liste'den seçili sayfayı göster
  - Örnek: `seciliSayfa = 0` → `DashboardScreen()` gösterilir

- **Satır 37-67:** `BottomNavigationBar`
  - Alt menü (4 buton)
  - `currentIndex` → Hangi buton seçili (maviye boyar)
  - `onTap` → Butona tıklayınca ne olur?

- **Satır 39-43:** `onTap` fonksiyonu
  - Kullanıcı bir butona tıkladığında çalışır
  - `setState()` ile `seciliSayfa`'yı günceller
  - Widget yeniden çizilir → Yeni sayfa gösterilir

**Akış Örneği:**
```
Kullanıcı "Kayıt" butonuna tıkladı
  ↓
onTap(1) çalıştı
  ↓
setState(() => seciliSayfa = 1)
  ↓
Widget yeniden çizildi
  ↓
body: sayfalar[1] → KayitScreen gösterildi
```

---

### 3. **dashboard_screen.dart** - Dashboard Ekranı

**Tam Kod:**
```dart
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
```

**Widget Ağacı:**
```
Center
└── Column (dikey)
    ├── Text ("Hoşgeldiniz")
    ├── SizedBox (boşluk 20px)
    └── Row (yatay)  
        ├── InfoBox ("Ciro", "0 TL")
        ├── SizedBox (boşluk 10px)
        └── InfoBox ("Kasa", "0 TL")
```

**Açıklama:**
- **Center:** İçeriği ekranın ortasına koyar
- **Column:** Elemanları dikey sıralar (yukarıdan aşağıya)
- **mainAxisAlignment.center:** Dikey eksende ortalar
- **SizedBox:** Boşluk bırakır
- **Row:** Elemanları yatay sıralar (soldan sağa)
- **InfoBox:** Tekrar kullanılabilir widget (widgets/info_box.dart'ta tanımlı)

---

### 4. **kayit_screen.dart** - Kayıt Formu

**Tam Kod:**
```dart
import 'package:flutter/material.dart';

// Gunluk kayit sayfasi
class KayitScreen extends StatefulWidget {
  const KayitScreen({super.key});

  @override
  State<KayitScreen> createState() => _KayitScreenState();
}

class _KayitScreenState extends State<KayitScreen> {
  // Metin kutulari icin
  final TextEditingController ciroKutusu = TextEditingController();
  final TextEditingController giderKutusu = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            'Günlük Kayıt',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          // Ciro giris yeri
          TextField(
            controller: ciroKutusu,
            decoration: const InputDecoration(
              labelText: 'Ciro',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.attach_money),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 15),
          // Gider giris yeri
          TextField(
            controller: giderKutusu,
            decoration: const InputDecoration(
              labelText: 'Gider',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.money_off),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 20),
          // Kaydet butonu
          ElevatedButton(
            onPressed: () {
              // Simdilik sadece mesaj goster
              // Database ileride eklenecek
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Kayıt başarılı!')),
              );
              // Kutulari temizle
              ciroKutusu.clear();
              giderKutusu.clear();
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            ),
            child: const Text('KAYDET'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    ciroKutusu.dispose();
    giderKutusu.dispose();
    super.dispose();
  }
}
```

**Önemli Kavramlar:**

**TextEditingController:**
- TextField'lardaki metni kontrol eder
- Kullanımı:
  ```dart
  ciroKutusu.text      // İçeriği oku
  ciroKutusu.clear()   // Temizle
  ```

**TextField:**
- `controller`: TextField'ı kontrol eder
- `decoration`: Görünüm (label, border, icon)
- `keyboardType`: Hangi klavye açılsın? (number = sayı klavyesi)

**SnackBar:**
- Ekranın altında kısa mesaj gösterir
- 2-3 saniye sonra kaybolur

**dispose() metodu:**
- Widget silindiğinde çalışır
- Controller'ları temizler
- Bellek sızıntısını önler

**Akış:**
```
Kullanıcı ciro/gider giriyor
  ↓
TextField'lar controller'a yaziyor
  ↓
"Kaydet" butonuna basiyor
  ↓
SnackBar mesaj gösteriyor
  ↓
Controller.clear() ile temizleniyor
  ↓
VERİ KAYBOLUR (henüz database yok)
```

---

### 5. **personel_screen.dart** - Personel Listesi

**Tam Kod:**
```dart
import 'package:flutter/material.dart';

// Personel listesi ekrani
class PersonelScreen extends StatelessWidget {
  const PersonelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Simdilik ornek personeller
    // Ileride database'den gelecek
    final List<Map<String, String>> personeller = [
      {'isim': 'Ahmet Yılmaz', 'pozisyon': 'Garson'},
      {'isim': 'Mehmet Kaya', 'pozisyon': 'Barmen'},
      {'isim': 'Ayşe Demir', 'pozisyon': 'Aşçı'},
    ];

    return Column(
      children: [
        // Baslik
        Container(
          padding: const EdgeInsets.all(16),
          child: const Text(
            'Personel Listesi',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        // Personel listesi
        Expanded(
          child: ListView.builder(
            itemCount: personeller.length,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  title: Text(personeller[index]['isim']!),
                  subtitle: Text(personeller[index]['pozisyon']!),
                  trailing: const Icon(Icons.arrow_forward_ios),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
```

**Veri Yapısı:**
```dart
List<Map<String, String>>  // Liste içinde Map
[
  {'isim': 'Ahmet', 'pozisyon': 'Garson'},  // 0. eleman
  {'isim': 'Mehmet', 'pozisyon': 'Barmen'}, // 1. eleman
  {'isim': 'Ayşe', 'pozisyon': 'Aşçı'},     // 2. eleman
]
```

**ListView.builder Nasıl Çalışır:**
```dart
ListView.builder(
  itemCount: 3,                    // 3 öğe var
  itemBuilder: (context, index) {  // Her öğe için
    // index = 0, 1, 2 sırayla gelir
    return Card(...);              // Card döndür
  },
)
```

**Liste Öğesi (Card + ListTile):**
- **Card:** Kartın görünümü (gölge, margin)
- **ListTile:** Standart liste öğesi
  - `leading`: Sol taraf (yuvarlak avatar + ikon)
  - `title`: Ana yazı (isim)
  - `subtitle`: Alt yazı (pozisyon)
  - `trailing`: Sağ taraf (ok işareti)

---

### 6. **veresiye_screen.dart** - Veresiye Listesi

**Tam Kod:**
```dart
import 'package:flutter/material.dart';

// Veresiye musteriler ekrani
class VeresiyeScreen extends StatelessWidget {
  const VeresiyeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Simdilik ornek musteri borclari
    // Ileride database'den gelecek
    final List<Map<String, dynamic>> borcluMusteriler = [
      {'isim': 'Hasan Bey', 'tutar': '2500 TL', 'durum': 'Ödenmedi'},
      {'isim': 'Ali Bey', 'tutar': '1000 TL', 'durum': 'Bekliyor'},
      {'isim': 'Veli Ağa', 'tutar': '750 TL', 'durum': 'Ödenmedi'},
    ];

    return Column(
      children: [
        // Baslik
        Container(
          padding: const EdgeInsets.all(16),
          child: const Text(
            'Veresiye Müşteriler',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        // Musteri listesi
        Expanded(
          child: ListView.builder(
            itemCount: borcluMusteriler.length,
            itemBuilder: (context, index) {
              final musteri = borcluMusteriler[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.red,
                    child: Icon(Icons.credit_card, color: Colors.white),
                  ),
                  title: Text(musteri['isim']!),
                  subtitle: Text(musteri['durum']!),
                  trailing: Text(
                    musteri['tutar']!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
```

**Personel listesinden farklar:**
- `Map<String, dynamic>` → Değerler farklı tipler olabilir
- `final musteri = borcluMusteriler[index]` → Değişken kullanımı
- Avatar kırmızı (borç olduğu için)
- Trailing'de tutar gösteriliyor (kırmızı, kalın)

---

### 7. **info_box.dart** - Tekrar Kullanılabilir Widget

**Tam Kod:**
```dart
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
```

**Parametreler:**
- `baslik`: Kutu başlığı (String)
- `deger`: Gösterilecek değer (String)
- `required`: Bu parametreler zorunlu

**Kullanımı:**
```dart
InfoBox(baslik: 'Ciro', deger: '2500 TL')
InfoBox(baslik: 'Kasa', deger: '1000 TL')
```

**Görünüm:**
- Açık mavi arka plan
- Yuvarlatılmış köşeler (10px)
- İç boşluk (padding)
- Dikey sıralı 2 yazı (başlık + değer)

---

## 🔄 Uygulama Akış Diyagramı

### Başlangıç:
```
1. Uygulama açılıyor
   ↓
2. main() çalışıyor
   ↓
3. runApp(TavernApp())
   ↓
4. MaterialApp oluşturuluyor
   ↓
5. HomePage gösteriliyor
   ↓
6. seciliSayfa = 0 (varsayılan)
   ↓
7. DashboardScreen gösteriliyor
```

### Sayfa Geçişi:
```
Kullanıcı "Personel" butonuna tıklıyor
   ↓
onTap(2) tetikleniyor
   ↓
setState(() {
  seciliSayfa = 2;
})
   ↓
Widget yeniden çiziliyor
   ↓
body: sayfalar[2]
   ↓
PersonelScreen gösteriliyor
```

### Veri Kaydetme:
```
Kullanıcı ciro/gider giriyor
   ↓
TextEditingController değerleri tutuyor
   ↓
"KAYDET" butonuna basıyor
   ↓
onPressed() çalışıyor
   ↓
SnackBar mesaj gösteriyor
   ↓
Controller.clear() ile temizleniyor
   ↓
VERİ KAYBOLUR ❌
(Veritabanı olmadığı için)
```

---

## 💡 Flutter Temel Kavramları

### Widget Nedir?
- **Her şey widget**
- Ekrandaki görsel elemanlar
- Örnek: Text, Button, Container, Card...

### StatelessWidget vs StatefulWidget

**StatelessWidget:**
- Değişmeyen widget
- `build()` metodu bir kez çalışır
- Örnek: DashboardScreen, PersonelScreen

**StatefulWidget:**
- Değişebilen widget
- `setState()` ile yeniden çizilir
- Örnek: HomePage, KayitScreen

### setState()
```dart
setState(() {
  seciliSayfa = index;  // Değişikliği yap
});
// Widget yeniden çizilir
```

### Build Metodu
```dart
@override
Widget build(BuildContext context) {
  return Container(...);  // Ne gösterileceğini döndür
}
```

---

## 🎨 UI Bileşenleri Sözlüğü

| Bileşen | Ne İşe Yarar? | Örnek |
|---------|---------------|-------|
| `Scaffold` | Sayfa iskeleti (AppBar, Body, Bottom) | `Scaffold(appBar: ..., body: ...)` |
| `AppBar` | Üst çubuk | `AppBar(title: Text('Başlık'))` |
| `Column` | Dikey sıralama | `Column(children: [...])` |
| `Row` | Yatay sıralama | `Row(children: [...])` |
| `Container` | Kutu (padding, margin, color) | `Container(padding: ...)` |
| `Text` | Yazı | `Text('Merhaba')` |
| `TextField` | Metin girişi | `TextField(controller: ...)` |
| `ElevatedButton` | Yükseltilmiş buton | `ElevatedButton(onPressed: ...)` |
| `Card` | Kart (gölgeli kutu) | `Card(child: ...)` |
| `ListTile` | Liste öğesi | `ListTile(title: ..., subtitle: ...)` |
| `ListView.builder` | Dinamik liste | `ListView.builder(itemCount: ...)` |
| `SizedBox` | Boşluk | `SizedBox(height: 20)` |
| `Icon` | İkon | `Icon(Icons.home)` |
| `CircleAvatar` | Yuvarlak avatar | `CircleAvatar(child: Icon(...))` |

---

## 📊 Veri Yapıları

### Liste (List)
```dart
final List<String> isimler = ['Ahmet', 'Mehmet', 'Ayşe'];
isimler[0]  // 'Ahmet'
isimler.length  // 3
```

### Map (Sözlük)
```dart
final Map<String, String> kisi = {
  'isim': 'Ahmet',
  'pozisyon': 'Garson'
};
kisi['isim']  // 'Ahmet'
```

### Liste + Map
```dart
final List<Map<String, String>> liste = [
  {'isim': 'Ahmet', 'pozisyon': 'Garson'},
  {'isim': 'Mehmet', 'pozisyon': 'Barmen'},
];
liste[0]['isim']  // 'Ahmet'
```

---

## 🎓 Kod Stili ve Öğrenci Dostu Özellikler

### Değişken İsimlendirme
Kodlar tamamen öğrenci dostu yazıldı:
- **Basit ve anlaşılır:** `ciroKutusu`, `giderKutusu` (Controller yerine)
- **Türkçe:** `seciliSayfa`, `sayfalar`, `personeller`, `borcluMusteriler`
- **Private önekler yok:** `seciliSayfa` (underscore kaldırıldı, yeni başlayanlar için)

### Yorumlar
- **Tüm yorumlar Türkçe:** Anlaşılır ve net
- **Büyük harfle başlıyor:** Profesyonel görünüm
- **Açıklayıcı:** "Metin kutulari icin" gibi sade ifadeler

### Öğrenme Odaklı
- **TODO yerine açık ifadeler:** "Ileride database'den gelecek"
- **Amatör ama temiz:** İlk proje yapan birinin yazacağı gibi
- **Karmaşık kavramlardan kaçınıldı:** Private değişkenler, fazla abstraction yok

---

## 🚀 Gelecek İçin Planlar

### Yapılacaklar:
- [ ] **SQLite veritabanı** ekle
- [ ] Gerçek veri **kaydetme/çekme**
- [ ] **Tarih seçici** ekle
- [ ] Personel **ekleme/silme**
- [ ] Veresiye **ödeme işlemleri**
- [ ] **Grafik** ve istatistikler
- [ ] **PDF rapor** çıktısı
- [ ] **Hesap makinesi** özelliği
- [ ] **Yedekleme** sistemi

### Veritabanı Eklenince Nasıl Olacak?

**Şu an:**
```dart
onPressed: () {
  // Sadece mesaj göster
  ScaffoldMessenger.of(context).showSnackBar(...);
}
```

**İleride:**
```dart
onPressed: () async {
  // Veritabanına kaydet
  await DatabaseHelper.insert({
    'ciro': ciroKutusu.text,
    'gider': giderKutusu.text,
    'tarih': DateTime.now(),
  });
  // Mesaj göster
  ScaffoldMessenger.of(context).showSnackBar(...);
}
```

---

## 📝 Özet

### Dosya Rolleri:

| Dosya | Türü | Görevi |
|-------|------|--------|
| `main.dart` | Başlangıç | Uygulamayı başlatır |
| `home_page.dart` | Navigation | 4 sayfa arası geçiş |
| `dashboard_screen.dart` | Ekran | Hoşgeldin + Ciro/Kasa |
| `kayit_screen.dart` | Form | Ciro/gider kayıt formu |
| `personel_screen.dart` | Liste | Personel gösterimi |
| `veresiye_screen.dart` | Liste | Veresiye gösterimi |
| `info_box.dart` | Widget | Tekrar kullanılabilir kutu |

### Önemli Noktalar:
✅ Statik veriler kullanılıyor (veritabanı yok)
✅ 4 ekran arası navigasyon çalışıyor
✅ Form giriş/temizleme çalışıyor
✅ Liste gösterimi çalışıyor
✅ Kod öğrenci dostu ve basit yazılmış
❌ Veri kalıcı değil (kapatınca kaybolur)
❌ Henüz database entegrasyonu yok

---

**Proje Durumu:** ✅ Çalışıyor, temel özellikler mevcut, kod amatör ve öğrenci dostu, veritabanı eklenmesi gerekiyor.
