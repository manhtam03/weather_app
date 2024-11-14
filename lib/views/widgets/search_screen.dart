import 'package:weather_app/controller/controller.dart';
import 'package:weather_app/models/search_city/city_model.dart';
import 'package:weather_app/views/screen/detail_weather.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import '../../firebase_auth/firebase_auth.dart';
import 'package:weather_app/views/widgets/login/welcome.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final db = FirebaseFirestore.instance;
  final FirebaseAuthService _auth = FirebaseAuthService();
  @override
  void initState() {
    super.initState();
    context.read<SettingState>().fetchFavoriteLocation();
  }

  bool checkFavorite(CityModel city, List<CityModel> listFavoriteCity) {
    return listFavoriteCity.any((favoriteCity) => favoriteCity.lat == city.lat && favoriteCity.lon == city.lon);
  }

  void buttonUnlike(CityModel city) {
    db
        .collection("favorite_city")
        .where('lat', isEqualTo: city.lat)
        .where('lon', isEqualTo: city.lon)
        .get()
        .then((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        snapshot.docs.first.reference.delete();
      }
    });
    context.read<SettingState>().fetchFavoriteLocation();
  }

  void buttonLike(CityModel city) {
    final favoriteCity = <String, dynamic>{'lat': city.lat, 'lon': city.lon, 'createAt': DateTime.now().toString()};
    db.collection("favorite_city").add(favoriteCity);
    context.read<SettingState>().fetchFavoriteLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Scaffold(
        extendBodyBehindAppBar: false,
        appBar: AppBar(
          backgroundColor: const Color(0xFF667EEA),
            elevation: 0,
            title: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.white.withOpacity(0.3),
                border: Border.all(color: Colors.grey),
               ),
              child: TextField(
                onChanged: (value) {
                  context.read<SettingState>().fetchListCityData(value);
                },
                decoration: const InputDecoration(
                  suffixIcon: Icon(Icons.search),
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.white),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 20, right: 10, top: 10),
                ),
              ),
          )),
        body: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter)
            ),
            child: Selector<SettingState, Tuple2<List<CityModel>, List<CityModel>>>(
              selector: (ctx, state) => Tuple2(state.listCity, state.listFavoriteCity),
              builder: (context, value, child) {
                return Column(
                  children: [
                    value.item1.isNotEmpty
                        ? Expanded(
                            child: ListView.separated(
                              separatorBuilder: (BuildContext context, int index) {
                                return Container(
                                  height: 1,
                                  width: double.infinity,
                                  color: Colors.black,
                                );
                              },
                              itemCount: value.item1.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailScreen(city: value.item1[index]),
                                      )),
                                  child: Container(
                                      height: 50,
                                      width: double.infinity,
                                      margin: const EdgeInsets.only(left: 20),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(Icons.location_on),
                                              const SizedBox(width: 10),
                                              Text(
                                                '${value.item1[index].name},${value.item1[index].country}',
                                                style: const TextStyle(color: Colors.black),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(right: 15),
                                            child: GestureDetector(
                                                onTap: () {
                                                  if (checkFavorite(value.item1[index], value.item2)) {
                                                    buttonUnlike(value.item1[index]);
                                                  } else {
                                                    buttonLike(value.item1[index]);
                                                  }
                                                },
                                                child: checkFavorite(value.item1[index], value.item2)
                                                    ? const Icon(Icons.favorite, color: Colors.pink)
                                                    : const Icon(Icons.favorite_border)),
                                          ),
                                        ],
                                      )),
                                );
                              },
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 10, top: 10),
                                child: Text(
                                  'Thành phố yêu thích',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                height: 270,
                                width: double.infinity,
                                child: ListView.separated(
                                  separatorBuilder: (BuildContext context, int index) {
                                    return Container(
                                      height: 1,
                                      width: double.infinity,
                                      color: Colors.black,
                                    );
                                  },
                                  itemCount: value.item2.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => DetailScreen(city: value.item2[index]),
                                          )),
                                      child: Container(
                                          height: 50,
                                          width: double.infinity,
                                          margin: const EdgeInsets.only(left: 20),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  const Icon(Icons.location_on),
                                                  const SizedBox(width: 10),
                                                  Text(
                                                    '${value.item2[index].name},${value.item2[index].country}',
                                                    style: const TextStyle(color: Colors.black),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(right: 15),
                                                child: GestureDetector(
                                                    onTap: () {
                                                      buttonUnlike(value.item2[index]);
                                                    },
                                                    child: checkFavorite(value.item2[index], value.item2)
                                                        ? const Icon(Icons.favorite, color: Colors.pink)
                                                        : const Icon(Icons.favorite_border)),
                                              ),
                                            ],
                                          )),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 330,),
                              ListTile(
                                title: ElevatedButton(
                                  onPressed: () async {
                                    await _auth.signOut();
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const Welcome()));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueGrey.withOpacity(0.6),
                                  ),
                                  child: const Text(
                                    "Đăng xuất",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
