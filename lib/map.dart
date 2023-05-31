import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daypix/login.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

class MapPage extends StatefulWidget {
  final uid;
  const MapPage({super.key, required this.uid});

  @override
  State<MapPage> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  final List<Marker> markers = [];
  final Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(36.1013342, 129.3909425),
    zoom: 14.4746,
  );

  // final String documentId;

  // Map(this.documentId);

  @override
  Widget build(BuildContext context) {
    final userRef = FirebaseFirestore.instance.collection(widget.uid);

    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection(widget.uid).snapshots(),
      builder: (context, snapshot) {
        final docu = snapshot.data!.docs;

        for (int i = 0; i < docu.length; i++) {
          double lat = double.parse(docu[i]['lat']);
          double lon = double.parse(docu[i]['lon']);
          print(lat);
          print(lon);
          markers.add(
            Marker(
              markerId: MarkerId('0'),
              position: LatLng(lat, lon),
              draggable: true,
            ),
          );
        }
        print(markers.length);
        return Scaffold(
          appBar: AppBar(),
          body: GoogleMap(
            markers: Set.from(markers),
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              print("I'm map");
              _controller.complete(controller);
            },
          ),
        );
      },
    );

    // return Scaffold(
    //     appBar: AppBar(
    //       title: const Text("why?"),
    //     ),
    //     body: Placeholder()
    //     // GoogleMap(
    //     //   markers: Set.from(markers),
    //     //   initialCameraPosition: _kGooglePlex,
    //     //   onMapCreated: (GoogleMapController controller) {
    //     //     print("I'm map");
    //     //     _controller.complete(controller);
    //     //   },
    //     // ),
    //     );

    // return FutureBuilder<Object>(
    //     future: FirebaseFirestore.instance.collection(widget.uid).get(),
    //     builder: (context, AsyncSnapshot snapshot) {
    //       print(snapshot.data['lat']);
    //       return Scaffold(
    //         appBar: AppBar(
    //           title: const Text("why?"),
    //         ),
    //         body: GoogleMap(
    //           markers: Set.from(markers),
    //           initialCameraPosition: _kGooglePlex,
    //           onMapCreated: (GoogleMapController controller) {
    //             print("I'm map");
    //             _controller.complete(controller);
    //           },
    //         ),
    //       );
    //     });
  }
}
