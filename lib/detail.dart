import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daypix/home.dart';
import 'package:daypix/login.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final uID;
  final docID;
  const DetailPage({super.key, required this.uID, required this.docID});

  @override
  Widget build(BuildContext context) {
    final UserModel user =
        ModalRoute.of(context)!.settings.arguments as UserModel;
    return FutureBuilder<Object>(
        future: FirebaseFirestore.instance.collection(uID).doc(docID).get(),
        builder: (context, AsyncSnapshot snapshot) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  // Navigator.pushNamed(context, '/home'); // TODO : 상의하기
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                      settings: RouteSettings(arguments: user),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.home_outlined,
                  size: 40,
                ),
              ),
              title: Text(snapshot.data['date']),
            ),
            body: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const SizedBox(width: 10),
                      const Icon(Icons.location_on),
                      const SizedBox(width: 10),
                      Text(
                        snapshot.data['address'],
                        style: TextStyle(fontSize: 20),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    children: [
                      SizedBox(width: 10),
                      Icon(Icons.cloud),
                      SizedBox(width: 10),
                      Text(
                        "Cloudy",
                        style: TextStyle(fontSize: 20),
                      ), // TODO: 날씨 API
                    ],
                  ),
                  const SizedBox(height: 20),
                  Stack(
                    children: [
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30.0),
                          child: Image.network(
                            snapshot.data['img'],
                            fit: BoxFit.fill,
                            width: 400.0,
                            height: 400.0,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 15,
                        right: 15,
                        child: Image.asset(
                          "assets/emoji/${snapshot.data['emoji']}.png",
                          width: 40,
                          color: Colors.white,
                        ),
                      ),
                      Positioned(
                        bottom: 15,
                        left: 50,
                        right: 50,
                        child: Text(
                          snapshot.data['text'],
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(20),
                          backgroundColor:
                              const Color(0xff214894), // <-- Button color
                          foregroundColor: Colors.white, // <-- Splash color
                        ),
                        child: const Icon(Icons.ios_share,
                            color: Colors.white, size: 30),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}

// class NetworkHelper {
//   static final NetworkHelper _instance = NetworkHelper._internal();
//   factory NetworkHelper() => _instance;
//   NetworkHelper._internal();

//   Future getData(String url) async {
//     http.Response response = await http.get(Uri.parse(url));

//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else {
//       print(response.statusCode);
//     }
//   }
// }

// class Weather {
//   double? temp;
//   double? tempMax;
//   double? tempMin;
//   String? condition;
//   int? conditionId;
//   int? humidity;

//   Weather({this.temp, this.tempMax, this.tempMin, this.condition, this.conditionId, this.humidity});
//   }
  
 
// class OpenWeatherService {
//   final String _apiKey = dotenv.env['openWeatherApiKey']!;
//   final String _baseUrl = dotenv.env['openWeatherApiBaseUrl']!;

//   Future getWeather() async {
//     MyLocation myLocation = MyLocation();
//     developer.log("myLocation called in network");
//     try {
//       await myLocation.getMyCurrentLocation();
//     } catch (e) {
//       developer.log("error : getLocation ${e.toString()}");
//     }

//     final weatherData = NetworkHelper().getData(
//         '$_baseUrl?lat=${myLocation.latitude}&lon=${myLocation.longitude}&appid=$_apiKey&units=metric');
//     return weatherData;
//   }
// }
  
// enum LoadingStatus { completed, searching, empty }

// class WeatherProvider with ChangeNotifier {
//   final Weather _weather =
//       Weather(temp: 20, condition: "Clouds", conditionId: 200, humidity: 50);
//   Weather get weather => _weather;

//   LoadingStatus _loadingStatus = LoadingStatus.empty;
//   LoadingStatus get loadingStatus => _loadingStatus;

//   String _message = "Loading...";
//   String get message => _message;

//   final OpenWeatherService _openWeatherService = OpenWeatherService();

//   Future<void> getWeather() async {
//     _loadingStatus = LoadingStatus.searching;

//     final weatherData = await _openWeatherService.getWeather();
//     if (weatherData == null) {
//       _loadingStatus = LoadingStatus.empty;
//       _message = 'Could not find weather. Please try again.';
//     } else {
//       _loadingStatus = LoadingStatus.completed;
//       weather.condition = weatherData['weather'][0]['main'];
//       weather.conditionId = weatherData['weather'][0]['id'];
//       weather.humidity = weatherData['main']['humidity'];
//       weather.temp = weatherData['main']['temp'];
//       weather.temp = (weather.temp! * 10).roundToDouble() / 10;
//     }

//     notifyListeners();
//   }
