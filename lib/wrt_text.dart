import 'dart:io';

import 'package:flutter/material.dart';

import 'package:daypix/detail.dart';
import 'package:daypix/location.dart';

var isText = 0;
String emoji = "";

class WrtTextPage extends StatefulWidget {
  final path;
  const WrtTextPage({super.key, required this.path});

  @override
  State<WrtTextPage> createState() => _WrtTextPageState();
}

class _WrtTextPageState extends State<WrtTextPage> {
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: () {
                print(_textController.text);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DetailPage()),
                );
              },
              style: TextButton.styleFrom(
                fixedSize: const Size(75, 10),
                backgroundColor: const Color(0xff214894),
              ),
              child: const Text("DONE",
                  style: TextStyle(
                    color: Colors.white,
                  ))),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30.0),
              child: Image.asset(
                'assets/default_pic1.jpeg',
                width: 350.0,
                height: 350.0,
                fit: BoxFit.fill,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  print('text');
                  isText = 1;
                  setState(() {});
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff214894),
                    minimumSize: const Size(60, 40)),
                child: const Icon(
                  Icons.text_fields,
                  size: 20,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              const Emoji(),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  print('map');
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => Loca(
                  //             title: '',
                  //           )),
                  // );
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff214894),
                    minimumSize: const Size(60, 40)),
                child: const Icon(
                  Icons.location_on,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: isText == 1
                  ? TextField(
                      controller: _textController,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.transparent,
                        labelText: 'How was your day?',
                      ),
                    )
                  : const SizedBox()),
        ],
      ),
    );
  }
}

class Emoji extends StatelessWidget {
  const Emoji({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                height: 300, // 모달 높이 크기
                decoration: const BoxDecoration(
                  color: Colors.white, // 모달 배경색
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(0), // 모달 좌상단 라운딩 처리
                    topRight: Radius.circular(0), // 모달 우상단 라운딩 처리
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            emoji = "happy";
                          },
                          child: SizedBox(
                            width: 50,
                            child: Column(children: [
                              Image.asset(
                                'assets/emoji/happy.png',
                                width: 50,
                                fit: BoxFit.fill,
                              ),
                              const Text("Happy")
                            ]),
                          ),
                        ),
                        const SizedBox(width: 20),
                        InkWell(
                          onTap: () {
                            emoji = "sad";
                          },
                          child: SizedBox(
                            width: 50,
                            child: Column(children: [
                              Image.asset(
                                'assets/emoji/sad.png',
                                width: 50,
                                fit: BoxFit.fill,
                              ),
                              const Text("Sad")
                            ]),
                          ),
                        ),
                        const SizedBox(width: 20),
                        InkWell(
                          onTap: () {
                            emoji = "angry";
                          },
                          child: SizedBox(
                            width: 50,
                            child: Column(children: [
                              Image.asset(
                                'assets/emoji/angry.png',
                                width: 50,
                                fit: BoxFit.fill,
                              ),
                              const Text("Angry")
                            ]),
                          ),
                        ),
                        const SizedBox(width: 20),
                        InkWell(
                          onTap: () {
                            emoji = "bored";
                          },
                          child: SizedBox(
                            width: 50,
                            child: Column(children: [
                              Image.asset(
                                'assets/emoji/bored.png',
                                width: 50,
                                fit: BoxFit.fill,
                              ),
                              const Text("Bored")
                            ]),
                          ),
                        ),
                        const SizedBox(width: 20),
                        InkWell(
                          onTap: () {
                            emoji = "love";
                          },
                          child: SizedBox(
                            width: 50,
                            child: Column(children: [
                              Image.asset(
                                'assets/emoji/love.png',
                                width: 50,
                                fit: BoxFit.fill,
                              ),
                              const Text("Love")
                            ]),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            emoji = "sick";
                          },
                          child: SizedBox(
                            width: 50,
                            child: Column(children: [
                              Image.asset(
                                'assets/emoji/sick.png',
                                width: 50,
                                fit: BoxFit.fill,
                              ),
                              const Text("Sick")
                            ]),
                          ),
                        ),
                        const SizedBox(width: 20),
                        InkWell(
                          onTap: () {
                            emoji = "sleepy";
                          },
                          child: SizedBox(
                            width: 50,
                            child: Column(children: [
                              Image.asset(
                                'assets/emoji/sleepy.png',
                                width: 50,
                                fit: BoxFit.fill,
                              ),
                              const Text("Sleepy")
                            ]),
                          ),
                        ),
                        const SizedBox(width: 20),
                        InkWell(
                          onTap: () {
                            emoji = "Think";
                          },
                          child: SizedBox(
                            width: 50,
                            child: Column(children: [
                              Image.asset(
                                'assets/emoji/think.png',
                                width: 50,
                                fit: BoxFit.fill,
                              ),
                              const Text("Think")
                            ]),
                          ),
                        ),
                        const SizedBox(width: 20),
                        InkWell(
                          onTap: () {
                            emoji = "wink";
                          },
                          child: SizedBox(
                            width: 50,
                            child: Column(children: [
                              Image.asset(
                                'assets/emoji/wink.png',
                                width: 50,
                                fit: BoxFit.fill,
                              ),
                              const Text("Wink")
                            ]),
                          ),
                        ),
                        const SizedBox(width: 20),
                        InkWell(
                          onTap: () {
                            emoji = "hungry";
                          },
                          child: SizedBox(
                            width: 50,
                            child: Column(children: [
                              Image.asset(
                                'assets/emoji/hungry.png',
                                width: 50,
                                fit: BoxFit.fill,
                              ),
                              const Text("Hungry")
                            ]),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            });
      },
      child: Container(
        width: 70.0,
        height: 40.0,
        decoration: BoxDecoration(
          color: const Color(0xff214894),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(
          Icons.tag_faces_sharp,
          size: 20,
          color: Colors.white,
        ),
      ),
    );
  }
}
