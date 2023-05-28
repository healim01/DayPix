// import 'dart:js';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// import 'package:kpostal/kpostal.dart';
// import 'package:remedi_kopo/remedi_kopo.dart';
// import 'package:path/path.dart';
// import 'dart:js';

// final _AddressController = TextEditingController();

// // _addressAPI() async {
// //   KopoModel model = await Navigator.push(
// //     context as BuildContext,
// //     CupertinoPageRoute(
// //       builder: (context) => RemediKopo(),
// //     ),
// //   );

// //   _AddressController.text =
// //       '${model.zonecode!} ${model.address!} ${model.buildingName}';
// // }

// // Widget AddressText() {
// //   return GestureDetector(
// //     onTap: () {
// //       HapticFeedback.mediumImpact();
// //       _addressAPI();
// //     },
// //     child: Column(children: [
// //       Text(
// //         '주소',
// //         style: TextStyle(fontSize: 15, color: Colors.amber),
// //       ),
// //       TextField(
// //         enabled: false,
// //         decoration: InputDecoration(isDense: false),
// //         controller: _AddressController,
// //         style: TextStyle(fontSize: 20),
// //       )
// //     ]),
// //   );
// // }

// class LocationPage extends StatefulWidget {
//   const LocationPage({super.key});

//   @override
//   State<LocationPage> createState() => _LocationPageState();
// }

// class _LocationPageState extends State<LocationPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Column(children: [
// // Use callback.
//         Icon(Icons.abc),
//         AddressText(),
//         // TextButton(
//         //   onPressed: () async {
//         //     await Navigator.push(
//         //         context,
//         //         MaterialPageRoute(
//         //           builder: (_) => KpostalView(
//         //             useLocalServer: true,
//         //             localPort: 8080,
//         //             callback: (Kpostal result) {
//         //               print(result.address);
//         //             },
//         //           ),
//         //         ));
//         //   },
//         //   child: const Text('Search!'),
//         // ),

// // Not use callback.
//         // TextButton(
//         //   onPressed: () async {
//         //     Kpostal result = await Navigator.push(
//         //         context, MaterialPageRoute(builder: (_) => KpostalView()));
//         //     print(result.address);
//         //   },
//         //   child: const Text('Search!!'),
//         // ),
//       ]),
//     );
//   }
// }

// Widget AddressText() {
//   return GestureDetector(
//     onTap: () {
//       HapticFeedback.mediumImpact();
//       _addressAPI(); // 카카오 주소 API
//     },
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text('주소',
//             style: TextStyle(fontSize: 15, color: Colors.blueGrey)),
//         TextFormField(
//           enabled: false,
//           decoration: const InputDecoration(
//             isDense: false,
//           ),
//           controller: _AddressController,
//           style: const TextStyle(fontSize: 20),
//         ),
//       ],
//     ),
//   );
// }

// // _addressAPI() async {
// //   KopoModel model = await Navigator.push(
// //     context,
// //     CupertinoPageRoute(
// //       builder: (context) => RemediKopo(),
// //     ),
// //   );
// //   _AddressController.text =
// //       '${model.zonecode!} ${model.address!} ${model.buildingName!}';
// // }

import 'package:flutter/material.dart';
import 'package:kpostal/kpostal.dart';

class Loca extends StatefulWidget {
  Loca({Key? key, required this.title}) : super(key: key);

  final String title;

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
        title: Text(widget.title),
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
