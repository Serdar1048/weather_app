import 'package:dio/dio.dart'; // HTTP istekleri için kullanılan Dio paketi
import 'package:geocoding/geocoding.dart'; // Koordinatlardan adres bilgisi almak için
import 'package:geolocator/geolocator.dart'; // Konum bilgisi almak için
import 'package:hava_durumu/models/weather_model.dart'; // Hava durumu model sınıfı

class WeatherService {
  // Konumu alıp şehir adını döndüren fonksiyon
  Future<String> _getLocation() async {
    // Konum servisi açık mı kontrolü
    final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Future.error("Konum servisiniz kapali."); // Eğer kapalıysa hata döner
    }

    // Konum izni verilmiş mi kontrol edilir
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission(); // İzin istenir
    }
    if (permission == LocationPermission.denied) {
      Future.error("Konum izni vermelisiniz."); // Hâlâ reddedildiyse hata döner
    }

    // Kullanıcının mevcut konumunu al
    final Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high, // Yüksek doğrulukla konum al
    );

    // Konumdan şehir/il bilgisi almak için placemark kullanılır
    final List<Placemark> placeMark = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    // Şehir ismi placemark içinden alınır
    final String? city = placeMark[0].administrativeArea;
    if (city == null)
      Future.error("Bir sorun oluştu!"); // Şehir alınamazsa hata döner

    return city!; // Şehri döndür
  }

  // Hava durumu verilerini API'den çekip WeatherModel listesi olarak döndürür
  Future<List<WeatherModel>> getWeatherData() async {
    final String city =
        await _getLocation(); // Kullanıcının konumundan şehir alınır

    // API URL'si hazırlanır (şehir adı dahil)
    String url =
        "https://api.collectapi.com/weather/getWeather?data.lang=tr&data.city=$city";

    // API için gerekli yetki ve içerik başlıkları
    const Map<String, dynamic> headers = {
      "authorization":
          "apikey 4I8DBYg8ETDeJrEZwwa0Pl:3Ht4IwjahVH2H75O2ecEDa", // API key
      "content-type": "application/json",
    };

    final dio = Dio(); // Dio HTTP istemcisi oluşturulur
    final response = await dio.get(
      url,
      options: Options(headers: headers),
    ); // GET isteği yapılır

    if (response.statusCode != 200)
      return Future.error("Bir sorun oluştu!"); // Başarısızsa hata

    final List list = response.data['result']; // API'den gelen veriler alınır
    // Her JSON nesnesi WeatherModel'a dönüştürülür
    final List<WeatherModel> weatherList =
        list.map((e) => WeatherModel.fromJson(e)).toList();

    return weatherList; // Hazır liste döndürülür
  }
}
