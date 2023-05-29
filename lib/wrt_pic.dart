import 'dart:io';
import 'dart:math';

// import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'package:daypix/wrt_text.dart';

final storageRef = FirebaseStorage.instance.ref();

class WrtPicPage extends StatefulWidget {
  final String date;
  const WrtPicPage({super.key, required this.date});

  @override
  State<WrtPicPage> createState() => _WrtPicPageState();
}

class _WrtPicPageState extends State<WrtPicPage> {
  var imagePath = '';
  var imgURL = '';
  var docID = '';

  File? _imgGallery;
  Future pickImageGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      imagePath = image.name;
      setState(
        () => _imgGallery = File(image.path),
      );
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  File? _imgCamera;
  Future pickImageCamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      imagePath = image.name;
      setState(() => _imgCamera = File(image.path));
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: null,
        builder: (context, snapshot) {
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.date), // TODO : remove
            ),
            body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Center(
                    child: imgURL == ''
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(30.0),
                            child: Image.asset(
                              'assets/default_pic1.jpeg',
                              width: 350.0,
                              height: 350.0,
                              fit: BoxFit.fill,
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(30.0),
                            child: Image.network(
                              imgURL,
                              fit: BoxFit.fill,
                              width: 350.0,
                              height: 350.0,
                            ),
                          ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () async {
                          await pickImageGallery();
                          final ref =
                              storageRef.child('images').child(imagePath);

                          imgURL = '';
                          if (imagePath != '') {
                            await ref.putFile(_imgGallery!);
                            await storageRef
                                .child('images')
                                .child(imagePath)
                                .getDownloadURL()
                                .then((v) => imgURL = v)
                                .catchError((error) =>
                                    print("Failed to add user: $error"));
                          }
                          setState(() {});
                        },
                        tooltip: 'Pick Image from Gallery',
                        icon: const Icon(
                          Icons.image,
                          size: 50,
                        ),
                      ),
                      IconButton(
                        onPressed: pickImageCamera,
                        tooltip: 'Pick Image from Camera',
                        icon: const Icon(
                          Icons.camera_alt,
                          size: 50,
                        ),
                      ),
                    ],
                  ),
                  const Expanded(child: SizedBox()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () async {
                            final user = FirebaseAuth.instance.currentUser;
                            print(imgURL);

                            await FirebaseFirestore.instance
                                .collection(
                                    'post') // .collection('post/${user?.uid}')
                                .add({
                                  'date': widget.date,
                                  'img': imgURL,
                                  'text': "",
                                  'emoji': '',
                                  "lat": "",
                                  "lon": "",
                                })
                                .catchError((error) =>
                                    print("Failed to add user: $error"))
                                .then(
                                    (DocumentReference doc) => docID = doc.id);

                            print(docID);

                            if (!mounted) return;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WrtTextPage(
                                        docID: docID,
                                        img: _imgGallery!.path,
                                      )),
                            );
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  const Color(0xff214894))),
                          child: const Text("NEXT",
                              style: TextStyle(
                                color: Colors.white,
                              ))),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        });
  }
}
