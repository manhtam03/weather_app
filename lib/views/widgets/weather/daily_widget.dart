// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/models/info/daily.dart';
import 'package:geolocator/geolocator.dart';

import 'package:weather_app/services/weather_services.dart';


class DailyWidget extends StatefulWidget {
  const DailyWidget({super.key});

  @override
  State<DailyWidget> createState() => _DailyWidget();
}

class _DailyWidget extends State<DailyWidget> {
  final _weatherService = WeatherService();
  List <WeatherForecastModel>? daysReport = [];
  Future<void> _fetchApi() async {
    Position position = await _weatherService.getCoordinate();
    try {
      final _7daysReport = await _weatherService.get7daysReport(position.latitude, position.longitude);
      setState(() {
        daysReport = _7daysReport;
      });
    } catch(e) {
      print("failed loading 7days report in widget");
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchApi();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.lightBlueAccent.withOpacity(0.2),
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.transparent.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.blue.withOpacity(0.7),
            Colors.blue.withOpacity(0.5),
          ],
        ),
      ),
      width: 400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.topLeft,
            margin: const EdgeInsets.only(bottom: 10),
            child: const Text(
              "Dự báo 7 ngày",
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Column(
            children: [
              for (final dailyForecast in daysReport!)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 80,
                        child: Text(
                          dailyForecast.date,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      const SizedBox(width: 79),
                      SizedBox(
                        height: 35,
                        width: 35,
                        child: Image.network(
                          dailyForecast.icon,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  '${dailyForecast.temperatureMax}°',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                                const Text(
                                  '/',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  '${dailyForecast.temperatureMin}°',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ]
                          ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
