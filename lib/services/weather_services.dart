import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/models/info/daily.dart';
import 'package:weather_app/models/info/hourly.dart';
import 'package:weather_app/models/info/weather.dart';
import 'package:weather_app/models/search_city/city_model.dart';
import 'package:weather_app/models/search_city/weather_model.dart';
// import 'package:geocoding/geocoding.dart';

class WeatherService {
  String apiKey = 'ce09cf76b3533f2704dade05d9ebbb45';

  Future<http.Response> get(String path) async {
    print('Fetching data from: $path');
      return await http.get(Uri.parse(path));
  }

  //lấy vị trí hiện tại
  Future<Position> getCoordinate() async{
    bool check = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission = await Geolocator.checkPermission();
    if (!check) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location Permission denied');
      }
    }
    Position position = await Geolocator.getCurrentPosition();
    return position;
  }

  Future<String?> getCurrentCity() async {
    String? city;
    Position position = await getCoordinate();
    var url = 'https://api.geoapify.com/v1/geocode/reverse?lat=${position.latitude}&lon=${position.longitude}&apiKey=26071b30fe7f420790532f5fadac905b';
    final response = await get(url);
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      city = '${json['features'][0]['properties']['city']}, ${json['features'][0]['properties']['country']}';
    } else {
      print('error fetch geo api');
    }
    return city!;
  }


  Future<Weather> getWeather(double lat, double lon) async {
    var url = 'https://api.openweathermap.org/data/3.0/onecall?lat=$lat&lon=$lon&appid=$apiKey&units=metric&lang=vi';
    final response = await get(url);
    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  // Future<List<HourlyForecast>?> getHourReport(double lat, double long) async {
  //   List <HourlyForecast> result = [];
  //   try {
  //     var url = 'https://api.openweathermap.org/data/3.0/onecall?lat=$lat&lon=$long&appid=$apikey&units=metric&lang=vi';
  //     final response = await http.get(Uri.parse(url));
  //     if (response.statusCode == 200) {
  //       final _resposnse = jsonDecode(response.body);
  //       final temp = (_resposnse['hourly']) as List;
  //       final _24hours = temp.take(24).toList();
  //       result = (_24hours).map((item) {
  //           return HourlyForecast.fromJson(item);
  //       }).toList();
  //     }
  //     return result;
  //   } catch(e) {
  //     print('error to get hour report');
  //     return null;
  //   }
  // }

  Future<List<HourlyForecast>> getHourReport(double lat, double lon) async {
    var url = 'https://api.openweathermap.org/data/3.0/onecall?lat=$lat&lon=$lon&appid=$apiKey&units=metric&lang=vi';
    final response = await get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['hourly'] as List;
      return data.map((item) => HourlyForecast.fromJson(item)).toList();
    }
    return [];
  }

  Future<List<WeatherForecastModel>> get7daysReport(double lat, double lon) async {
    var url = 'https://api.openweathermap.org/data/3.0/onecall?lat=$lat&lon=$lon&appid=$apiKey&units=metric&lang=vi';
    final response = await get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['daily'] as List;
      return data.map((item) => WeatherForecastModel.fromJson(item)).toList();
    }
    return [];
  }

  // Future<List<WeatherForecastModel>?> get7daysReport(double lat, double long) async {
  //   List <WeatherForecastModel> result = [];
  //   try {
  //     var url = 'https://api.openweathermap.org/data/3.0/onecall?lat=$lat&lon=$long&appid=$apiKey&units=metric&lang=vi';
  //     final response = await http.get(Uri.parse(url));
  //     if (response.statusCode == 200) {
  //       final _resposnse = jsonDecode(response.body);
  //       final temp = (_resposnse['daily']) as List;
  //       final skip = temp.sublist(1);
  //       result = skip.map((item) {
  //         return WeatherForecastModel.fromJson(item);
  //       }).toList();
  //     }
  //     return result;
  //   } catch(e) {
  //     print('error to get weather forecast report');
  //     return null;
  //   }
  // }

  
  //Tìm kiếm thành phố
  Future<List<CityModel>> searchCity(String name) async {
    var url = 'http://api.openweathermap.org/geo/1.0/direct?q=$name&limit=10&appid=$apiKey';
    final response = await get(url);
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body.map<CityModel>((item) => CityModel.fromMap(item)).toList();
    }
    return [];
  }
  
  Future<CityModel> getCityFromCoordinates(double lat, double lon) async {
    var url = 'http://api.openweathermap.org/geo/1.0/reverse?lat=$lat&lon=$lon&limit=1&appid=$apiKey';
    final response = await get(url);
    if (response.statusCode == 200) {
      return CityModel.fromMap(jsonDecode(response.body).first);
    }
    throw Exception('Failed to load city data');
  }

  Future<WeatherData> getWeatherData(double lat, double lon) async {
    var url = 'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey';
    final response = await get(url);
    if (response.statusCode == 200) {
      return WeatherData.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}