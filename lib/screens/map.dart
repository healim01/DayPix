import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daypix/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

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

  @override
  Widget build(BuildContext context) {
    final UserModel user =
        ModalRoute.of(context)!.settings.arguments as UserModel;
    final userRef = FirebaseFirestore.instance.collection(user.uid);

    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection(user.uid).snapshots(),
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
  }
}
