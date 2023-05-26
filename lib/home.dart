import 'package:daypix/wrt_pic.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("DayPix"),
      ),
      body: Column(
        children: [
          TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const WrtPicPage()),
                );
              },
              child: const Text("Writing Pic Page"))
        ],
      ),
    );
  }
}
