// import 'dart:html';

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
          if (snapshot.data == null) return const Scaffold();
          List<String> items = List.from(snapshot.data['labels']);
          return Scaffold(
            appBar: AppBar(
              leading: Row(
                children: [
                  const SizedBox(
                    width: 8,
                  ),
                  IconButton(
                    onPressed: () {
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
                      size: 30,
                    ),
                  ),
                ],
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
                        style: const TextStyle(fontSize: 20),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const SizedBox(width: 10),
                      snapshot.data['weather_icon'] == 800
                          ? const Icon(Icons.sunny)
                          : snapshot.data['weather_icon'] / 100 == 8 ||
                                  snapshot.data['weather_icon'] / 100 == 2
                              ? const Icon(Icons.cloud)
                              : snapshot.data['weather_icon'] / 100 == 3 ||
                                      snapshot.data['weather_icon'] / 100 == 5
                                  ? const Icon(Icons.beach_access)
                                  : snapshot.data['weather_icon'] / 100 == 6
                                      ? const Icon(Icons.ac_unit)
                                      : const Icon(Icons.cloud),
                      const SizedBox(width: 10),
                      Text(
                        snapshot.data['weather'],
                        style: const TextStyle(fontSize: 20),
                      ),
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (String label in items)
                        Text(
                          ' #$label ',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.blue,
                          ),
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
