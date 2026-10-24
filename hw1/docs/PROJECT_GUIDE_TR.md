# Projeyi anlamak

Projenin dosya yapısı, durum yönetimi ve temel etkileşimleri.

## Nereden başlamalı?

1. `lib/main.dart`: Program `main()` ile başlar. `MaterialApp`, temayı ve ilk ekranı belirler.
2. `lib/models/campus_event.dart`: Bir etkinliğin alanları, favori/katılım durumu ve filtreleme fonksiyonu.
3. `lib/data/events.dart`: Altı hayali etkinlik. Liste her açılışta yeni nesneler üretir.
4. `lib/screens/explore_screen.dart`: Üç sekme, arama kutusu, kategoriler ve liste. Ana `StatefulWidget` burada.
5. `lib/widgets/event_card.dart`: Tekrar kullanılan `StatelessWidget` kartı, kategori etiketi, kontenjan etiketi ve bilgi satırı.
6. `lib/screens/event_details_screen.dart`: Detay, onay pencereleri ve büyütülmüş görsel ekranı.
7. `lib/theme.dart`: Ortak renkler, Manrope fontu ve Material teması.

## State nasıl çalışıyor?

Ana ekranın `_events` listesi uygulama oturumundaki etkinlik nesnelerini tutar. Her nesnede `isFavorite` ve `_isJoined` vardır. Bir işlem yapıldığında `setState` ilgili ekranı tekrar çizdirir.

Detay ekranına aynı etkinlik nesnesi ve iki callback gönderilir. Detaydan favoriye eklemek veya katılmak ana ekrandaki veriyi değiştirir. Detay ekranı da kendi `setState` çağrısıyla güncellenir. `Navigator.pop` ile geri dönünce ana liste yeniden çizilir.

Arama metni ve seçili kategori ana ekranda bir kez tutulur. Sekmeyi değiştirmek bu değerleri sıfırlamaz. `filterEvents`, önce sekmeye ait etkinlikleri seçer; ardından kategori ve `trim().toLowerCase()` ile normalize edilmiş başlık aramasını birlikte uygular.

## Kontenjan neden bozulmuyor?

`available = initialAvailable - (isJoined ? 1 : 0)`

Başlangıç kontenjanı sabittir; katılım bir boolean değerdir. Bu yüzden aynı etkinliğe ikinci kez katılmak kontenjanı tekrar azaltamaz. `join()` hem doluluk hem mevcut katılım kontrolü yapar. `cancelParticipation()` sadece gerçekten katılım varsa çalışır. Son yere katıldığınızda kontenjan sıfır olur ama `isJoined` doğru olduğundan iptal düğmesi kullanılabilir kalır.

Onay penceresinden `true` dönmedikçe veri değişmez. **No**, dışarı dokunma ve geri düğmesi işlemi iptal eder. İşlem sırasında `_confirming` ikinci bir pencerenin açılmasını engeller.

## Görseller ve font

Üç PNG uygulamayla birlikte paketlenir. Font da dört yerel TTF dosyasından yüklenir. `pubspec.yaml` bu dosyaları bildirir. Ağdan veri/görsel/font indiren uygulama kodu yoktur. Görsel üretim betiği uygulamayı çalıştırmak için gerekli değildir.

## Kontrol senaryoları

- `Sunset Tennis Social`: Son bir yer. Katılın, iptal edin, kontenjanı gözleyin.
- `AI Ideas, Human Conversations`: Başlangıçta dolu. Katılma düğmesi pasif.
- Aramaya `  FLUTTER  ` yazın; Technology ile eşleşir, Sports ile eşleşmez.
- Favoriye ekleyip Details ve Favorites arasında gidin.
- Details görseline çift dokunun; geri düğmesiyle iki aşamada listeye dönün.
- Uygulamayı tamamen kapatıp açınca favoriler/katılımlar sıfırlanır. Bu ödevin izin verdiği davranıştır.
