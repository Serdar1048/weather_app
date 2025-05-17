import 'package:flutter/material.dart'; // Flutter'ın temel widgetlarını içe aktarır
import 'package:hava_durumu/screens/home_page.dart'; // HomePage sayfasını içe aktarır (kendi oluşturduğun dosya)

// Uygulamanın başlangıç noktası
void main() {
  runApp(const Home()); // Home widget'ını çalıştırır
}

// Uygulamanın ana widget'ı
class Home extends StatelessWidget {
  const Home({
    super.key,
  }); // Constructor, widget'e key parametresi verir (gerekirse)

  @override
  Widget build(BuildContext context) {
    // MaterialApp: Uygulama temasını ve navigasyonu yönetir
    return MaterialApp(
      home: HomePage(),
    ); // Ana sayfa olarak HomePage widget'ını gösterir
  }
}
