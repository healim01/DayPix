import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final uID;
  final docID;
  final img;
  const DetailPage(
      {super.key, required this.uID, required this.docID, required this.img});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Object>(
        future: FirebaseFirestore.instance.collection(uID).doc(docID).get(),
        builder: (context, AsyncSnapshot snapshot) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/home'); // TODO : 상의하기
                  // Navigator.pushReplacement(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => const HomePage(),
                  //     settings: RouteSettings(
                  //       arguments: UserModel(
                  //         uid: id ?? "",
                  //         name: name ?? "",
                  //         email: email ?? "",
                  //         url: url ?? "",
                  //       ),
                  //     ),
                  //   ),
                  // );
                },
                icon: const Icon(
                  Icons.home_outlined,
                  size: 30,
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
                      Text(snapshot.data['address'])
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    children: [
                      SizedBox(width: 10),
                      Icon(Icons.cloud),
                      SizedBox(width: 10),
                      Text("Cloudy"), // TODO: 날씨 API
                    ],
                  ),
                  const SizedBox(height: 20),
                  Stack(
                    children: [
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30.0),
                          child: Image.file(
                            File(img),
                            fit: BoxFit.fill,
                            width: 350.0,
                            height: 350.0,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 15,
                        right: 15,
                        child: Image.asset(
                          "assets/emoji/${snapshot.data['emoji']}.png",
                          width: 30,
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
