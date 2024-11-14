class WeatherForecastModel {
  final String date;
  final String temperatureMax;
  final String temperatureMin;
  final String pop; 
  final String icon;


  WeatherForecastModel({
    required this.date,
    required this.temperatureMax,
    required this.temperatureMin,
    required this.pop,
    required this.icon,
  });


  @override
  String toString() {
    return 'WeatherForecastModel{date: $date, temperatureMax: $temperatureMax, temperatureMin: $temperatureMin, pop: $pop}';
  }

  factory WeatherForecastModel.fromJson(Map<String, dynamic> json) {
    String getDate(int timestamp) {
      var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
      String result = date.toString().split(" ")[0];
      return result;
    }

    String dateToWeekDay(String date) {
      DateTime newdate = DateTime.parse(date);
      int dayofWeek = newdate.weekday;
      String dayName = '';
      switch (dayofWeek) {
        case 1:
          dayName = 'Thứ Hai';
          break;
        case 2:
          dayName = 'Thứ Ba';
          break;
        case 3:
          dayName = 'Thứ Tư';
          break;
        case 4:
          dayName = 'Thứ Năm';
          break;
        case 5:
          dayName = 'Thứ Sáu';
          break;
        case 6:
          dayName = 'Thứ Bảy';
          break;
        case 7:
          dayName = 'Chủ Nhật';
          break;
        default:
          dayName = 'Invalid day';
      }
      return dayName;
    }

    String icon(String code) {
      return 'https://openweathermap.org/img/wn/$code@2x.png';
    }
    
    return WeatherForecastModel(
        date: dateToWeekDay(getDate(json['dt'])),
        temperatureMax: json['temp']['max'].toString(),
        temperatureMin: json['temp']['min'].toString(),
        pop: json['pop'].toString(),
        icon: icon(json['weather'][0]['icon']),
    );
  }
}
