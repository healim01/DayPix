import 'dart:io';

// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'package:daypix/wrt_text.dart';

class WrtPicPage extends StatefulWidget {
  const WrtPicPage({super.key});

  @override
  State<WrtPicPage> createState() => _WrtPicPageState();
}

class _WrtPicPageState extends State<WrtPicPage> {
  var imagePath = '';

  File? _imgGallery;
  Future pickImageGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      imagePath = image.name;
      setState(() => _imgGallery = File(image.path));
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
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Center(
                child: _imgGallery == null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(30.0),
                        child: Image.asset(
                          'assets/default_pic1.jpeg',
                          width: 350.0,
                          height: 350.0,
                          fit: BoxFit.fill,
                        ),
                      )
                    : Image.file(File(_imgGallery!.path))),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: pickImageGallery,
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
            // TextField(
            //   controller: _productnameController,
            //   decoration: const InputDecoration(
            //     filled: true,
            //     labelText: 'Product Name',
            //   ),
            // ),
            // const SizedBox(height: 5),
            // TextField(
            //   controller: _priceController,
            //   decoration: const InputDecoration(
            //     filled: true,
            //     labelText: 'Price',
            //   ),
            // ),
            // const SizedBox(height: 5),
            // TextField(
            //   controller: _descController,
            //   decoration: const InputDecoration(
            //     filled: true,
            //     labelText: 'Description',
            //   ),
            // ),
            const Expanded(child: SizedBox()),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const WrtTextPage(path: 'haha')),
                      );
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(const Color(0xff214894))),
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
  }
}
