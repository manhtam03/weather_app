class CityModel {
    late String name;
    late double lat;
    late double lon;
    late String country;
    String? state;
  
  CityModel({
    required this.name,
    required this.lat,
    required this.lon,
    required this.country,
    this.state
  });



  factory CityModel.fromMap(Map<String, dynamic> map) {
      String nullcheck(String? a, String b) {
        if (a == null) {
          return b;
        } else {
          return a;
        } 
      }
    return CityModel(
      name: nullcheck(map['local_names']['en'], map['name']),
      lat: map['lat'] ?? 0,
      lon: map['lon'] ?? 0,
      country: map['country'] ?? '',
      state: map['state'] ?? '',
    );
  }
}
