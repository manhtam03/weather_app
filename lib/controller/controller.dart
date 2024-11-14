import 'package:weather_app/models/search_city/city_model.dart';
import 'package:weather_app/models/search_city/location_model.dart';
import 'package:weather_app/models/search_city/weather_model.dart';
import 'package:weather_app/services/weather_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SettingState extends ChangeNotifier {
  final WeatherService _weatherService = WeatherService();
  final db = FirebaseFirestore.instance;
  List<CityModel> listCity = [];
  List<LocationModel> listLocation = [];
  List<CityModel> listFavoriteCity = [];
  WeatherData? weatherData;

  //Tìm kiếm thành phố
  Future fetchListCityData(String name) async {
    listCity = await _weatherService.searchCity(name);
    notifyListeners();
  }

  Future fetchFavoriteLocation() async {
    listLocation = [];
    listFavoriteCity = [];
    listCity = [];
    final QuerySnapshot snapshot = await db.collection("favorite_city").get();
    final List<DocumentSnapshot> documents = snapshot.docs;
    for (var doc in documents) {
      listLocation.add(LocationModel.fromMap(doc.data() as Map<String,dynamic>));
    }
    List<CityModel> tmp = [];
    for (var location in listLocation) {
        tmp.add(await fetchCityData(location.lat.toString(),  location.lon.toString()));
    }
    listFavoriteCity = tmp;
    notifyListeners();
  }

  // Lấy thông tin thành phố
  Future<CityModel> fetchCityData(String lat, String lon) async {
  return await _weatherService.getCityFromCoordinates(double.parse(lat), double.parse(lon));
  }


  Future fetchLatLonCityData(String lat, String lon) async {
    weatherData = await _weatherService.getWeatherData(double.parse(lat), double.parse(lon));
    notifyListeners();
  }

  // Future fetchListCityData(String name) async {
  //   listCity = [];
  //   final Response response = await ApiServices()
  //       .get('http://api.openweathermap.org/geo/1.0/direct?q=$name&limit=10&appid=ce09cf76b3533f2704dade05d9ebbb45');
  //   final body = jsonDecode(response.body);
  //   for (var i in body) {
  //     CityModel city = CityModel.fromMap(i);
  //     listCity.add(city);
  //   }
  //   notifyListeners();
  // }

  // // Lấy danh sách các thành phố yêu thích và dữ liệu của chúng
  // Future fetchFavoriteLocation() async {
  //   listLocation = await _getFavoriteLocationsFromDB();
  //   listFavoriteCity = await Future.wait(
  //     listLocation.map((loc) => _weatherService.getCityFromCoordinates(loc.lat, loc.lon)),
  //   );
  //   notifyListeners();
  // }

  // Future<CityModel> fetchCityData(String lat,String lon) async {
  //   final Response response = await ApiServices().get(
  //       'http://api.openweathermap.org/geo/1.0/reverse?lat=$lat&lon=$lon&limit=1&appid=fadf9668e3f907defd8764e9a3debdb8');
  //   final body = jsonDecode(response.body);
  //   return CityModel.fromMap(body.first);
  // }

  // Future fetchLatLonCityData(String lat, String lon) async {
  //   final Response response = await ApiServices().get(
  //       'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=fadf9668e3f907defd8764e9a3debdb8');
  //   final body = jsonDecode(response.body);
  //   weatherData = WeatherData.fromMap(body);
  //   notifyListeners();
  // }
}
