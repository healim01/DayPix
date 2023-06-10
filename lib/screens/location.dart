import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kpostal/kpostal.dart';
import 'package:http/http.dart' as http;

class LocationPage extends StatefulWidget {
  final uID;
  final docID;
  const LocationPage({super.key, required this.uID, required this.docID});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  String address = '-';
  String kakaoLatitude = '-';
  String kakaoLongitude = '-';
  String weather = '';
  int weatherIcon = 0;
  final _openweatherkey = '434f863823f4faa77e10d6893d0d3b21';

  @override
  Widget build(BuildContext context) {
    Future<void> getWeatherData({
      required String lat,
      required String lon,
    }) async {
      var str = Uri.parse(
          'http://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$_openweatherkey');

      print(str);
      var response = await http.get(str);

      if (response.statusCode == 200) {
        var data = response.body;
        var dataJson = jsonDecode(data); // string to json
        // print('data = $data');
        // print('${dataJson['main']['temp']}');
        print('${dataJson['weather'][0]['main']}');
        weather = dataJson['weather'][0]['main'];
        print('${dataJson['weather'][0]['id']}');
        weatherIcon = dataJson['weather'][0]['id'];
      } else {
        print('response status code = ${response.statusCode}');
      }
    }

    return KpostalView(
      useLocalServer: true,
      localPort: 8080,
      kakaoKey: '1dfce4d9fc58503f87e067a944c655a6',
      callback: (Kpostal result) {
        setState(() async {
          address = result.address;
          kakaoLatitude = result.kakaoLatitude.toString();
          kakaoLongitude = result.kakaoLongitude.toString();

          print(address);
          print(kakaoLatitude);
          print(kakaoLongitude);

          await getWeatherData(lat: kakaoLatitude, lon: kakaoLongitude);

          await FirebaseFirestore.instance
              .collection(widget.uID)
              .doc(widget.docID)
              .update({
            "address": address,
            "lat": kakaoLatitude,
            "lon": kakaoLongitude,
            "weather_icon": weatherIcon,
            "weather": weather
          }).catchError((error) => print("Failed to add user: $error"));
        });
      },
    );
  }
}
