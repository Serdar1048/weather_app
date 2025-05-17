import 'package:flutter/material.dart'; // Flutter UI bileşenlerini içe aktarır
import 'package:hava_durumu/models/weather_model.dart'; // Hava durumu verileri için model sınıfı
import 'package:hava_durumu/services/weather_service.dart'; // API veya veri sağlayıcı servis sınıfı

// Stateful widget: sayfa duruma göre kendini yenileyebilir
class HomePage extends StatefulWidget {
  const HomePage({super.key}); // Constructor (isteğe bağlı key parametresi)

  @override
  State<HomePage> createState() => _HomePageState(); // State sınıfını döndürür
}

class _HomePageState extends State<HomePage> {
  List<WeatherModel> _weathers = []; // Hava durumu verilerini tutacak liste

  // Hava durumu verilerini çeken async fonksiyon
  void _getWeatherData() async {
    _weathers = await WeatherService().getWeatherData(); // Servisten veri çek
    setState(() {}); // Ekranı yenile
  }

  @override
  void initState() {
    _getWeatherData(); // Sayfa yüklenince verileri çek
    super.initState(); // Varsayılan başlatıcıyı çağır
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Sayfa iskeleti (app bar, body vs. barındırır)
      body: Center(
        // Ortalanmış içerik
        child: ListView.builder(
          // Dinamik liste oluşturur
          itemCount: _weathers.length, // Eleman sayısı kadar listeler
          itemBuilder: (context, index) {
            final WeatherModel weather =
                _weathers[index]; // Her bir hava durumu elemanını al
            return Container(
              padding: const EdgeInsets.all(20), // İç boşluk
              margin: const EdgeInsets.all(15), // Dış boşluk
              decoration: BoxDecoration(
                // Kutunun stili
                color: Colors.blueGrey.shade50, // Arka plan rengi
                borderRadius: BorderRadius.circular(10), // Köşe yuvarlama
              ),
              child: Column(
                // İçeriği dikey olarak sıralar
                children: [
                  Image.network(
                    weather.ikon,
                    width: 100,
                  ), // Hava durumu simgesi
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 15,
                      bottom: 25,
                    ), // Başlık boşlukları
                    child: Text(
                      "${weather.gun}\n ${weather.durum.toUpperCase()} ${weather.derece}°", // Gün + durum + derece
                      textAlign: TextAlign.center, // Ortalı metin
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  Row(
                    // Yatay iki sütun
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween, // Sütunlar arası boşluk
                    children: [
                      Column(
                        // Sol sütun
                        crossAxisAlignment:
                            CrossAxisAlignment.start, // Sola hizalı
                        children: [
                          Text("Min: ${weather.min} °"), // Minimum sıcaklık
                          Text("Max: ${weather.max} °"), // Maksimum sıcaklık
                        ],
                      ),
                      Column(
                        // Sağ sütun
                        crossAxisAlignment:
                            CrossAxisAlignment.end, // Sağa hizalı
                        children: [
                          Text("Gece: ${weather.gece} °"), // Gece sıcaklığı
                          Text("Nem: ${weather.nem}"), // Nem oranı
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
