class HourlyForecast {
  final String time;
  final String temperature;
  final String condition;
  final String icon;

  HourlyForecast({
    required this.time,
    required this.temperature,
    required this.condition,
    required this.icon,
  });


  @override
  String toString() {
    return 'HourlyForecast{time: $time, temperature: $temperature, condition: $condition, icon: $icon}\n';
  }

  factory HourlyForecast.fromJson(Map<String, dynamic> json) {
    String icon(String code) {
      return 'https://openweathermap.org/img/wn/$code@2x.png';
    }

    String reformatDate(int timestamp) {
      var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
      String result = date.toString().split(" ")[1].substring(0, 5);
      return result;
    }

    return HourlyForecast(
        time: reformatDate(json['dt']),
        temperature: json['temp'].toString(),
        condition: json['weather'][0]['main'],
        icon: icon(json['weather'][0]['icon'])
    );
  }
}