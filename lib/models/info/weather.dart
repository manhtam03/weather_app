class Weather {
  final String temperature;
  final String condition;
  final String maxTemp;
  final String minTemp;
  final String icon;
  final String uvIndex;
  final String humidity;
  final String visibility;
  final String wind;
  final String sunRise, sunSet;
  final String rain;

  Weather({
    required this.temperature,
    required this.condition,
    required this.maxTemp,
    required this.minTemp,
    required this.icon,
    required this.uvIndex,
    required this.humidity,
    required this.visibility,
    required this.wind,
    required this.sunRise,
    required this.sunSet,
    required this.rain
  });


  @override
  String toString() {
    return 'Weather{temperature: $temperature, rain: $rain, condition: $condition, maxTemp: $maxTemp, minTemp: $minTemp, icon: $icon, uvIndex: $uvIndex, humidity: $humidity, visibility: $visibility, wind: $wind, sunRise: $sunRise, sunSet: $sunSet}';
  }

  factory Weather.fromJson(Map<String, dynamic> json) {
    String getHour(int timeStamp) {
      DateTime date = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
      String result = date.toString().split(" ")[1].substring(0, 5);
      return result;
    }
    String icon(String code) {
      return 'https://openweathermap.org/img/wn/$code@2x.png';
    }
    // String condition = json['current']['weather'][0]['description'];
    return Weather(
      temperature: json['current']['temp'].toString(),
      condition: json['current']['weather'][0]['description'],
      maxTemp: json['daily'][0]['temp']['max'].toString(),
      minTemp: json['daily'][0]['temp']['min'].toString(),
      icon: icon(json['daily'][0]['weather'][0]['icon']),
      uvIndex: json['current']['uvi'].toString(),
      humidity: json['current']['humidity'].toString(),
      wind: json['current']['wind_speed'].toString(),
      sunRise: getHour(json['current']['sunrise']),
      sunSet: getHour(json['current']['sunset']),
      visibility: json['current']['visibility'].toString(),
      rain: json['daily'][0]['rain'].toString()
    );
  }
}


