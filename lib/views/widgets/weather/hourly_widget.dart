import 'package:flutter/material.dart';
import 'package:weather_app/models/info/hourly.dart';
import 'package:geolocator/geolocator.dart';

import 'package:weather_app/services/weather_services.dart';

class HourlyWidget extends StatefulWidget {
  const HourlyWidget({super.key});

  @override
  State<HourlyWidget> createState() => _HourlyWidget();
}

class _HourlyWidget extends State<HourlyWidget> {
  final _weatherService = WeatherService();
  List <HourlyForecast>? hourReport = [];

  Future<void> _fetchApi() async {
    Position position = await _weatherService.getCoordinate();
    try {
      final _hourReport = await _weatherService.getHourReport(position.latitude, position.longitude);
      setState(() {
        hourReport = _hourReport;
      });
    } catch(e) {
      print("failed loading hour report in widget");
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
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(28),
      ),
      height: 120,
      child: hourReport != null
          ? ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: hourReport!.length,
              itemBuilder: (context, index) {
              final forecast = hourReport![index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 12),
                  Text(
                    // forecast.time ?? '...',
                    forecast.time,
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                  ),
                  Image.network(
                    // forecast.icon ?? '...',
                    forecast.icon,
                    height: 60,
                    width: 60,
                  ),
                  Text(
                    // "${forecast.temperature ?? '...'}°C",
                    "${forecast.temperature}°C",
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                  ),
                  const SizedBox(height: 6),

                ],
              ),
            );
          },
        ) : const Center(child: CircularProgressIndicator()),
    );
  }
}
