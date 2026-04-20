# Tavern App - Sistem ve Kullanım Rehberi

Bu belge uygulamanın teknik altyapısını ve son kullanıcı (işletmeci) tarafından nasıl kullanılması gerektiğini özetler.

---

## BÖLÜM 1: Teknik Mimari ve Veri Akışı (Geliştirici İçin)

Uygulama, standart bir klasik yapıdan ziyade **Reactive State Management** (Reaktif Durum Yönetimi - Riverpod) kullanılarak Katmanlı Mimari (Layered Architecture) ile inşa edilmiştir.

### Uygulama İçi Veri Akışı Şeması (Process Logic)

```mermaid
graph TD
    classDef ui fill:#4A90E2,stroke:#fff,stroke-width:2px,color:#fff;
    classDef logic fill:#50E3C2,stroke:#fff,stroke-width:2px,color:#111;
    classDef state fill:#F5A623,stroke:#fff,stroke-width:2px,color:#fff;

    subgraph Arayüz (Kullanıcının Gördüğü Yerler)
        UI_Kayit[Kayıt Ekranı]:::ui
        UI_Personel[Personel Ekranı]:::ui
        UI_Ozet[Özet Ekranı]:::ui
    end

    subgraph Durum Yönetimi (Riverpod Hafızası)
        STATE_Daily[DailyRecordProvider <br/> Ciro, Gider Merkezi]:::state
        STATE_Attendance[AttendanceProvider <br/> Var/Yok Durumu]:::state
    end

    subgraph İş Zekası (Matematik/Calculator)
        LOGIC_NetKasa[Net Kasa Hesaplayıcı]:::logic
        LOGIC_Bahsis[Kişi Başı Bahşiş Hesaplayıcı]:::logic
    end
    
    %% Kullanıcı girişleri State'i günceller
    UI_Kayit -- Kullanıcı Kaydet'e Basar --> STATE_Daily
    UI_Personel -- Kullanıcı Ekleme Yapar --> STATE_Attendance
    
    %% State güncellendiğinde Matematik modülleri Tetiklenir
    STATE_Daily -. Formülü İşletir .-> LOGIC_NetKasa
    STATE_Daily -. Bahşiş ve Personel .-> LOGIC_Bahsis
    STATE_Attendance -. Çalışan Sayısı .-> LOGIC_Bahsis
    
    %% UI yeniden çizilir
    LOGIC_NetKasa -- Anında Ekranı Saniye Atlattırmadan Yeniler --> UI_Ozet
    LOGIC_Bahsis -- Anında Yeniler --> UI_Ozet
```

### Katmanların Çalışma Prensibi:
1. **Veri Okuma (UI Layer):** Ekranlarımız `ref.watch()` komutuyla uygulamanın beynine (State) atılmış radarlar gibidir. State değiştikçe ekran anında tetiklenip kendini yeniler.
2. **Eylem ve Veri Gönderme (Action Layer):** `ref.read().notifier` komutu ile formlardan alınan girdiler ilgili Riverpod Hafızasına gönderilir. (Ör: `updateCiro(15000)`)
3. **Kendi Kendine Çalışan Domino Etkisi (Reactive Logic):** `calculator_provider.dart` içindeki hesaplayıcılarımız, ana değerlerde (Örn: Ciro veya bahşiş) en ufak bir değişiklik sezdiğinde matematiki formülleri kendiliğinden yeniden çalıştırır. Bize sadece sonucu "Özet" ekranında göstermek kalır.

---
---

## BÖLÜM 2: İşletme Sahibi İçin Kullanım Kılavuzu (Son Kullanıcı Kılavuzu)

Tavern App'e hoş geldiniz! Verilerin kaybolmaması ve matematiksel sürecin doğru işlemesi için uygulamayı aşağıdaki adımları izleyerek kullanmalısınız. Sistemin en büyük avantajı: **Bir yere veri girdiğinizde, kasanız otomatik olarak güncellenir.**

### 1️⃣ Güne Başlarken: Personel Yönetimi
İşletmeyi açtığınızda ilk yapmanız gereken şey çalışan sistemini kontrol etmektir.
- **Nasıl Yapılır:** Alt menüden `Personel` sekmesine gidin.
- **Kullanım:** Sağ alttaki **(+) Ekle** butonuna basarak bugün mekanda olacak personellerin adlarını, pozisyonlarını ve günlük yevmiyelerini sisteme dahil edin. İşi bırakan veya hatalı girilen personeli yanındaki Çöp Kutusu ikonuyla silebilirsiniz.
- **Neden Önemli?** Buraya eklediğiniz her personel, akşam bahşiş dağıtımı ve yevmiye dağıtımı algoritmalarına otomatik olarak dahil edilecektir.

### 2️⃣ Mesai İçinde: Cari / Veresiye Defteri
Müşterilerin veresiye hesaplarını manuel defterlere yazmanıza gerek kalmadı. 
- **Nasıl Yapılır:** Alt menüden `Veresiye` sekmesini açın.
- **Kullanım:** Sağ alt kısımdaki **(+)** butona basarak müşterinin adını ve veresiye (Borç) miktarını girin. Müşteri borcunu getirdiğinde isminin yanındaki **(Yenile) butonuna** basarak borcu "Ödendi" durumuna çekebilirsiniz. Liste yeşil renkle güncellenecektir.
- **Unutmayın:** Veresiye olarak deftere eklenen "tahsil edilmemiş" tutarlar, akşam gün sonu aldığınızda kasadan matematiksel olarak düşüleceği için işletmenizin cirosunu yanıltmaz.

### 3️⃣ Gün Sonu ve Hesap (Kayıt Ekranı)
Günün en kritik bölümüdür. Gece yarısı işletmeyi kapatırken yapacağınız işlemdir. 
- **Nereye Gidilir?** Alt menüden `Kayıt` sekmesine girilir.
- **Neler Girilmeli?**
  - **Tüm Ciro:** Kasaya giren tüm para (Kredi kartı + Nakit dahil).
  - **Giderler:** O gün yapılan tüm harcamalar (Örn: Manav, otopark, mutfak alışverişi).
  - **Toplanan Bahşiş:** Kasada müşterilerden toplanan havuz bahşiş miktarı.
  - **Kredi Kartı ile Çekilen:** Cironun ne kadarının kredi kartlarından tahsil edildiğini belirten tutar.
- **Uygula:** "Kaydet ve Güncelle" butonuna bastığınız anda, girdiğiniz bu sayılar mekanın kasasına iletilir.

### 4️⃣ Kasanın Müzikaline Şahit Olun (Özet Ekranı)
İşte uygulamanın asıl gücü buradadır. Verileri girdikten sonra alt menüdeki `Özet` sekmesine geçin. 
- **Net Kasa:** Yukarıda sizin için (Ciro + Bahşişler - Giderler - Veresiyeler - Kredi Kartı tahsilatları) düşülerek net o gün kasanızda kalan saf nakit parayı saniyesinde hesaplamış olacaktır.
- **Yoklama ve Kişi Başı Bahşiş:** Gün sonunda bütün personelleriniz aşağıda liste olarak gelecektir. İşe gelmeyen personelin yanındaki onay kutusuna dokunup onu dondurursanız; veya sadece o an orada çalışanları Checkbox ile (Tık atarak) işaretlerseniz, **Uygulama; Toplam bahşişi sadece tık attığınız mevcut personel sayısına saniyeler içinde dinamik olarak bölecek** ve üstte "Kişi Başı Bahşiş" kutusunda canlı canlı gösterecektir. Hesap makinelerine veda edebilirsiniz!
