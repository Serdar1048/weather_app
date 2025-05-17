import 'package:dio/dio.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hava_durumu/models/weather_model.dart';

class WeatherService {
  Future<String> _getLocation() async {
    //Konum açık mı kontrolü
    final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Future.error("Konum servisiniz kapali.");
    }

    //konum izni verilmiş mi kontrolü
    LocationPermission permission = await Geolocator.checkPermission();
    //konum izni vermemişse tekrar izin istedik
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    //yine vermemişse hata döndürdük
    if (permission == LocationPermission.denied) {
      Future.error("Konum izni vermelisiniz.");
    }

    //kullanıcının pozisyonunu aldık
    final Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    //kullanıcı pozisyonundan yerleşim noktasını bulduk
    final List<Placemark> placeMark = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    //yerleşimimizi yerleşim noktasından kaydettik
    final String? city = placeMark[0].administrativeArea;
    if (city == null) Future.error("Bir sorun oluştu!");

    return city!;
  }

  Future<List<WeatherModel>> getWeatherData() async {
    final String city = await _getLocation();
    String url =
        "https://api.collectapi.com/weather/getWeather?data.lang=tr&data.city=$city";
    const Map<String, dynamic> headers = {
      "authorization": "apikey 4I8DBYg8ETDeJrEZwwa0Pl:3Ht4IwjahVH2H75O2ecEDa",
      "content-type": "application/json",
    };

    final dio = Dio();
    final response = await dio.get(url, options: Options(headers: headers));

    if (response.statusCode != 200) return Future.error("Bir sorun oluştu!");
    final List list = response.data['result'];
    final List<WeatherModel> weatherList =
        list.map((e) => WeatherModel.fromJson(e)).toList();
    return weatherList;
  }
}
