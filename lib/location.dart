import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kpostal/kpostal.dart';

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

  @override
  Widget build(BuildContext context) {
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

          await FirebaseFirestore.instance
              .collection(widget.uID)
              .doc(widget.docID)
              .update({
            "address": address,
            "lat": kakaoLatitude,
            "lon": kakaoLongitude,
          }).catchError((error) => print("Failed to add user: $error"));

          print("??");
        });
      },
    );
  }
}

class Loca extends StatefulWidget {
  final docID;
  Loca({Key? key, required this.docID}) : super(key: key);

  @override
  _LocaState createState() => _LocaState();
}

class _LocaState extends State<Loca> {
  String postCode = '-';
  String address = '-';
  String latitude = '-';
  String longitude = '-';
  String kakaoLatitude = '-';
  String kakaoLongitude = '-';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.docID),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => KpostalView(
                      useLocalServer: true,
                      localPort: 1024,
                      // kakaoKey: '{Add your KAKAO DEVELOPERS JS KEY}',
                      callback: (Kpostal result) {
                        setState(() {
                          this.postCode = result.postCode;
                          this.address = result.address;
                          this.latitude = result.latitude.toString();
                          this.longitude = result.longitude.toString();
                          this.kakaoLatitude = result.kakaoLatitude.toString();
                          this.kakaoLongitude =
                              result.kakaoLongitude.toString();
                        });
                      },
                    ),
                  ),
                );
              },
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue)),
              child: Text(
                'Search Address',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Container(
              padding: EdgeInsets.all(40.0),
              child: Column(
                children: [
                  Text('postCode',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('result: ${this.postCode}'),
                  Text('address',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('result: ${this.address}'),
                  Text('LatLng', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                      'latitude: ${this.latitude} / longitude: ${this.longitude}'),
                  Text('through KAKAO Geocoder',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                      'latitude: ${this.kakaoLatitude} / longitude: ${this.kakaoLongitude}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
