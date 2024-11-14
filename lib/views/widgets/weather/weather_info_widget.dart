import 'package:flutter/material.dart';

class WeatherInfoGrid extends StatelessWidget {
  final String? uvIndex;
  final String? humidity;
  final String? visibility;
  final String? wind;
  final String? sunRise;
  final String? rainFall;

  const WeatherInfoGrid({
    super.key,
    this.uvIndex,
    this.humidity,
    this.visibility,
    this.wind,
    this.sunRise,
    this.rainFall
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
      ),
      itemCount: 6,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return _buildWeatherInfoBox(context, index);
      },
    );
  }

  Widget _buildWeatherInfoBox(BuildContext context, int index) {
    String title = '';
    String? value;
    String unit = ' ';
    IconData iconData = Icons.error;

    switch (index) {
      case 0:
        title = 'Chỉ số UV';
        value = uvIndex;
        iconData = Icons.wb_sunny;
        break;
      case 1:
        title = 'Mặt trời mọc';
        value = sunRise;
        iconData = Icons.sunny_snowing;
        break;
      case 2:
        title = 'Gió';
        value = wind;
        iconData = Icons.wind_power;
        unit = 'km/h';
        break;
      case 3:
        title = 'Lượng mưa';
        value = rainFall;
        iconData = Icons.water_outlined;
        unit = 'mm';
        break;
      case 4:
        title = 'Tầm nhìn';
        value = visibility;
        iconData = Icons.visibility;
        unit = 'm';
        break;
      case 5:
        title = 'Độ ẩm';
        value = humidity;
        iconData = Icons.water_drop;
        unit = '%';
        break;
    }

    return Container(
      margin: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: Colors.lightBlue.withOpacity(0.2),
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.transparent.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.blue.withOpacity(0.3),
            Colors.blueAccent.withOpacity(0.2),
          ],
        ),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ]
          ),
          const SizedBox(width: 15),
          Icon(iconData, color: Colors.white, size: 56),
          const SizedBox(height: 15),
          Center(
            child: Text(
              value != null ? value + unit : 'loading...',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}