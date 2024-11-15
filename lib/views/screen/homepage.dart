import 'package:weather_app/views/widgets/weather/daily_widget.dart';
import 'package:weather_app/models/info/weather.dart';
import 'package:weather_app/services/weather_services.dart';
import 'package:weather_app/views/widgets/weather/hourly_widget.dart';
import 'package:weather_app/views/widgets/weather/weather_info_widget.dart';
import 'package:weather_app/firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/views/widgets/search_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseAuthService auth = FirebaseAuthService();
  final _weatherService = WeatherService();
  Weather? weather;
  String? cityName;

  Future<void> _fetchWeather() async {
    Position position = await _weatherService.getCoordinate();
    try {
      final _cityName = await _weatherService.getCurrentCity();
      final _weather = await _weatherService.getWeather(position.latitude, position.longitude);
      setState(() {
        cityName = _cityName;
        weather = _weather;
        print(weather.toString());
      });
    } catch(e) {
      print("Failed loading today weather in widget");
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
            cityName ?? "loading..",
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      drawer: const SearchScreen(),
      // drawer: MyDrawer(),

      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.5, 1.0],
            ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 80,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${weather?.temperature ?? "..."}°C' ,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 60,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 10),
                                    height: 100,
                                    width: 100,
                                    child: Image.network(
                                      weather?.icon ?? "",
                                      color: Colors.white.withOpacity(0.9),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ]
                            ),

                            Text(
                              weather?.condition.toUpperCase() ?? "loading...",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'C: ${weather?.maxTemp ?? "..."}°C  ',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600
                                  ),
                                ),
                                Text(
                                  ' T: ${weather?.minTemp ?? "..."}°C',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            const HourlyWidget(),
                            const SizedBox(height: 30),
                            const DailyWidget(),
                            WeatherInfoGrid(
                              uvIndex: weather?.uvIndex,
                              humidity: weather?.humidity,
                              visibility: weather?.visibility,
                              wind: weather?.wind,
                              sunRise: weather?.sunRise,
                              rainFall: weather?.rain,
                            ),
                          ],
                        ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
