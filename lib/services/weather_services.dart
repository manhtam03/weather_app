import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/models/info/daily.dart';
import 'package:weather_app/models/info/hourly.dart';
import 'package:weather_app/models/info/weather.dart';
import 'package:weather_app/models/search_city/city_model.dart';
import 'package:weather_app/models/search_city/weather_model.dart';

class WeatherService {

  Future<http.Response> get(String path) async {
    print('Fetching data from: $path');
      return await http.get(Uri.parse(path));
  }

  //lấy vị trí hiện tại
  // Future<Position> getCoordinate() async{
  //   bool check = await Geolocator.isLocationServiceEnabled();
  //   LocationPermission permission = await Geolocator.checkPermission();
  //   if (!check) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       print('Location Permission denied');
  //     }
  //   }
  //   Position position = await Geolocator.getCurrentPosition();
  //   return position;
  // }

  Future<Position> getCoordinate() async {
    bool isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isServiceEnabled) {
      throw Exception("Location services are disabled. Please enable them in settings.");
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Chỉ yêu cầu nếu chưa có yêu cầu đang xử lý
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("Location permissions are denied by the user.");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          "Location permissions are permanently denied. Please enable them in app settings.");
    }
    return await Geolocator.getCurrentPosition();
  }


  Future<String?> getCurrentCity() async {
    Position? position = await getCoordinate();
    if (position == null) {
      print("Cannot fetch current city because location is unavailable.");
      return null;
    }
    var url = 'https://api.geoapify.com/v1/geocode/reverse?lat=${position.latitude}&lon=${position.longitude}&apiKey=26071b30fe7f420790532f5fadac905b';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      if (json['features'].isNotEmpty) {
        var city = '${json['features'][0]['properties']['city']}, ${json['features'][0]['properties']['country']}';
        return city;
      } else {
        print("No city data found in API response.");
      }
    } else {
      print("Error fetching city data: ${response.statusCode}");
    }
    return null; // Trả về null nếu không lấy được thành phố
  }


  // Future<String?> getCurrentCity() async {
  //   String? city;
  //   Position position = await getCoordinate();
  //   var url = 'https://api.geoapify.com/v1/geocode/reverse?lat=${position.latitude}&lon=${position.longitude}&apiKey=26071b30fe7f420790532f5fadac905b';
  //   final response = await http.get(Uri.parse(url));
  //   if (response.statusCode == 200) {
  //     var json = jsonDecode(response.body);
  //     city = '${json['features'][0]['properties']['city']}, ${json['features'][0]['properties']['country']}';
  //   } else {
  //     print('error fetch geo api');
  //   }
  //   return city!;
  // }


  Future<Weather> getWeather(double lat, double long) async {
    String apiKey = 'ce09cf76b3533f2704dade05d9ebbb45';

    var url = 'https://api.openweathermap.org/data/3.0/onecall?lat=$lat&lon=$long&appid=$apiKey&units=metric&lang=vi';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<List<HourlyForecast>?> getHourReport(double lat, double long) async {
    String apiKey = 'ce09cf76b3533f2704dade05d9ebbb45';

    List <HourlyForecast> result = [];
    try {
      var url = 'https://api.openweathermap.org/data/3.0/onecall?lat=$lat&lon=$long&appid=$apiKey&units=metric&lang=vi';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final _resposnse = jsonDecode(response.body);
        final temp = (_resposnse['hourly']) as List;
        final _24hours = temp.take(24).toList();
        result = (_24hours).map((item) {
            return HourlyForecast.fromJson(item);
        }).toList();
      }
      return result;
    } catch(e) {
      print('error to get hour report');
      return null;
    }
  }

  // Future<List<HourlyForecast>?> getHourReport(double lat, double lon) async {
  //   var url = 'https://api.openweathermap.org/data/3.0/onecall?lat=$lat&lon=$lon&appid=$apiKey&units=metric&lang=vi';
  //   final response = await get(url);
  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body)['hourly'] as List;
  //     return data.map((item) => HourlyForecast.fromJson(item)).toList();
  //   }
  //   return [];
  // }

  // Future<List<WeatherForecastModel>?> get7daysReport(double lat, double lon) async {
  //   var url = 'https://api.openweathermap.org/data/3.0/onecall?lat=$lat&lon=$lon&appid=$apiKey&units=metric&lang=vi';
  //   final response = await get(url);
  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body)['daily'] as List;
  //     return data.map((item) => WeatherForecastModel.fromJson(item)).toList();
  //   }
  //   return [];
  // }

  Future<List<WeatherForecastModel>?> get7daysReport(double lat, double long) async {
    String apiKey = 'ce09cf76b3533f2704dade05d9ebbb45';

    List <WeatherForecastModel> result = [];
    try {
      var url = 'https://api.openweathermap.org/data/3.0/onecall?lat=$lat&lon=$long&appid=$apiKey&units=metric&lang=vi';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final _resposnse = jsonDecode(response.body);
        final temp = (_resposnse['daily']) as List;
        final skip = temp.sublist(1);
        result = skip.map((item) {
          return WeatherForecastModel.fromJson(item);
        }).toList();
      }
      return result;
    } catch(e) {
      print('error to get weather forecast report');
      return null;
    }
  }

  
  //Tìm kiếm thành phố
  Future<List<CityModel>> searchCity(String name) async {
    String apiKey = 'ce09cf76b3533f2704dade05d9ebbb45';

    var url = 'http://api.openweathermap.org/geo/1.0/direct?q=$name&limit=10&appid=$apiKey';
    final response = await get(url);
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body.map<CityModel>((item) => CityModel.fromMap(item)).toList();
    }
    return [];
  }
  
  Future<CityModel> getCityFromCoordinates(double lat, double lon) async {
    String apiKey = 'fadf9668e3f907defd8764e9a3debdb8';
    var url = 'http://api.openweathermap.org/geo/1.0/reverse?lat=$lat&lon=$lon&limit=1&appid=$apiKey';
    final response = await get(url);
    if (response.statusCode == 200) {
      return CityModel.fromMap(jsonDecode(response.body).first);
    }
    throw Exception('Failed to load city data');
  }

  Future<WeatherData> getWeatherData(double lat, double lon) async {
    String apiKey = 'fadf9668e3f907defd8764e9a3debdb8';

    var url = 'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey';
    final response = await get(url);
    if (response.statusCode == 200) {
      return WeatherData.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}