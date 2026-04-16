# Android Studio'da Nasil Calistirilir

## 1. Projeyi Ac

1. Android Studio'yu ac
2. "File" > "Open" (veya "Open an existing Android Studio project")
3. `tavern_app` klasorunu sec
4. "OK" tikla

## 2. Flutter SDK Kontrolu

- Android Studio Flutter SDK'yi bulamazsa:
  - "File" > "Settings" > "Languages & Frameworks" > "Flutter"
  - Flutter SDK yolunu goster (genelde `C:\src\flutter` gibi bir yer)

## 3. Paketleri Yukle

Asagidaki komutlari terminalden calistir (veya Android Studio otomatik sorar):

```
flutter pub get
```

## 4. Emulator Ayarla

### Emulator yoksa:

1. Tool menusunden "Device Manager" ac
2. "Create Device" tikla
3. Bir telefon sec (ornegin: Pixel 5)
4. System Image indir (Android 13 - Tiramisu onerilir)
5. "Finish" de

### Emulator'u Baslat:

1. Device Manager'da emulator'un yanindaki "Play" butonuna bas
2. Emulator acilmasini bekle (ilk seferde yavas olabilir)

## 5. Uygulamayi Calistir

### Yontem 1: Run Butonu
- Ustteki yesil "Run" butonuna tikla (ucgen sekli)
- Veya `Shift + F10`

### Yontem 2: Terminal
```
flutter run
```

## 6. Hata Alirsaniz

### "No device found"
- Emulator acik mi kontrol et
- Terminal'de `flutter devices` yaz

### "Flutter SDK not found"
- Flutter yuklu mu? `flutter doctor` komutunu calistir
- Flutter PATH'e ekli mi kontrol et

### Build hatasi
```
flutter clean
flutter pub get
flutter run
```

## Kisayollar

- **Hot Reload**: `r` tusuna bas (kodda degisiklik yapinca)
- **Hot Restart**: `R` tusuna bas
- **Cikis**: `q` tusuna bas

---

## Basarili Oldugunda

Emulator'da uygulama acilacak ve 4 sekmeli ana ekrani goreceksin:
- Ana Sayfa (Ciro/Kasa)
- Kayit
- Personel  
- Veresiye
