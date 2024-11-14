class WeatherData {
  final Main main;
  final List<Weather1> weather;
  final double wind;
  final int visibility;
  
  WeatherData({
    required this.main,
    required this.weather,
    required this.wind,
    required this.visibility
  });

  factory WeatherData.fromMap(Map<String, dynamic> map) {
    return WeatherData(
      main: Main.fromMap(map['main']),
      weather: List<Weather1>.from(map['weather'].map((item) => Weather1.fromMap(item))),
      wind: map['wind']['speed'],
      visibility: map['visibility'],
    );
  }
}

class Main {
  int temp;
  int feelsLike;
  int pressure;
  int humidity;

  Main({
    required this.temp,
    required this.feelsLike,
    required this.pressure,
    required this.humidity,
  });

  factory Main.fromMap(Map<String, dynamic> map) => Main(
        temp: _convertToC(map['temp'].toDouble()),
        feelsLike: _convertToC(map['feels_like'].toDouble()),
        pressure: map['pressure'] ?? 0,
        humidity: map['humidity'] ?? 0,
      );
  static int _convertToC(double kelvin) {
    return (kelvin - 273.15).round();
  }
}


class Weather1 {
  int id;
  String main;
  String description;
  String icon;

  Weather1({
    required this.id,
    required this.main,
    required this.description,
    required this.icon,
  });

  factory Weather1.fromMap(Map<String, dynamic> map) => Weather1(
        id: map['id'],
        main: map['main'],
        description: map['description'],
        icon: map['icon'],
      );
}


