class LocationModel {
    late double lat;
    late double lon;
  
  LocationModel({
    required this.lat,
    required this.lon,
  });


  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      lat: map['lat'] ?? 0,
      lon: map['lon'] ?? 0,
    );
  }
}
