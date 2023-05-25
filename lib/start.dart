import 'package:flutter/material.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color.fromRGBO(33, 72, 148, 1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 60.0),
            const Center(
              child: Text(
                'DayPix',
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            Container(
              width: 300,
              height: 50,
              margin: EdgeInsets.only(bottom: 100),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextButton(
                child: const Text(
                  'Log In',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
