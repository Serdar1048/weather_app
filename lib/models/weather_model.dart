class WeatherModel {
  // Hava durumu için gerekli özellikler (veri alanları)
  final String gun; // Gün bilgisi (örnek: Pazartesi)
  final String ikon; // Hava durumu ikonu (URL)
  final String durum; // Hava durumu açıklaması (örnek: Güneşli)
  final String derece; // Günlük ortalama sıcaklık
  final String min; // Minimum sıcaklık
  final String max; // Maksimum sıcaklık
  final String gece; // Gece sıcaklığı
  final String nem; // Nem oranı

  // Constructor: sınıfın tüm alanlarını alarak nesne oluşturur
  WeatherModel(
    this.gun,
    this.ikon,
    this.durum,
    this.derece,
    this.min,
    this.max,
    this.gece,
    this.nem,
  );

  // JSON'dan veri alıp sınıfın alanlarına dönüştüren named constructor
  WeatherModel.fromJson(Map<String, dynamic> json)
    : gun = json['day'], // JSON'daki 'day' alanı -> gun
      ikon = json['icon'], // JSON'daki 'icon' alanı -> ikon
      durum = json['description'], // JSON'daki 'description' alanı -> durum
      derece = json['degree'], // JSON'daki 'degree' alanı -> derece
      min = json['min'], // JSON'daki 'min' alanı -> min
      max = json['max'], // JSON'daki 'max' alanı -> max
      gece = json['night'], // JSON'daki 'night' alanı -> gece
      nem = json['humidity']; // JSON'daki 'humidity' alanı -> nem
}
