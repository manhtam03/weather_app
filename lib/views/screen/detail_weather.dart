import 'package:weather_app/controller/controller.dart';
import 'package:weather_app/models/search_city/city_model.dart';
import 'package:weather_app/models/search_city/weather_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.city});
  final CityModel city;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SettingState>().fetchLatLonCityData(widget.city.lat.toString(), widget.city.lon.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.city.name),
        centerTitle: true,
      ),
      body: Selector<SettingState, WeatherData?>(
        selector: (ctx, state) => state.weatherData,
        builder: (context, value, child) {
          if (value == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Container(
                    height: 280,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  value.main.temp.toString(),
                                  style:
                                      const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
                                ),
                                const Text(
                                  'o',
                                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ],
                            ),
                            Text(
                              value.weather[0].description,
                              style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Image.network(
                          'https://openweathermap.org/img/wn/${value.weather[0].icon}@2x.png',
                          height: 150,
                          width: 200,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: GridView(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, crossAxisSpacing: 17),
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Độ ẩm', style: TextStyle(color: Colors.white, fontSize: 13)),
                              const SizedBox(height: 10),
                              Center(
                                child: Text('${value.main.humidity} %',
                                    style: const TextStyle(color: Colors.white, fontSize: 15)),
                              )
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Gió', style: TextStyle(color: Colors.white, fontSize: 13)),
                              const SizedBox(height: 10),
                              Center(
                                child:
                                    Text('${value.wind} m/s', style: const TextStyle(color: Colors.white, fontSize: 15)),
                              )
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Áp suất', style: TextStyle(color: Colors.white, fontSize: 13)),
                              const SizedBox(height: 10),
                              Center(
                                child: Text('${value.main.pressure} mb',
                                    style: const TextStyle(color: Colors.white, fontSize: 15)),
                              )
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Tầm nhìn', style: TextStyle(color: Colors.white, fontSize: 13)),
                              const SizedBox(height: 10),
                              Center(
                                child: Text('${value.visibility / 1000} km',
                                    style: const TextStyle(color: Colors.white, fontSize: 15)),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}
