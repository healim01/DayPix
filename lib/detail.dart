import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DayPix'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/');
            },
            icon: Icon(
              Icons.home_outlined,
              size: 30,
            ),
          ),
          SizedBox(width: 10)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Wednesday, Mar 29, 2023"),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Icon(Icons.location_on),
                SizedBox(width: 10),
                Text("HANDONG UNIV"),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.cloud),
                SizedBox(width: 10),
                Text("Cloudy"),
              ],
            ),
            SizedBox(height: 20),
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
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Icon(Icons.ios_share, color: Colors.white, size: 30),
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(20),
                    backgroundColor: Color(0xff214894), // <-- Button color
                    foregroundColor: Colors.white, // <-- Splash color
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
