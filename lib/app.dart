import 'package:flutter/material.dart';
import 'package:daypix/start.dart';
import 'package:daypix/home.dart';
import 'package:daypix/login.dart';
import 'package:daypix/signup.dart';
import 'package:daypix/profile.dart';

class DayPixApp extends StatelessWidget {
  const DayPixApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DayPix',
      initialRoute: '/',
      routes: {
        '/home': (BuildContext context) => const HomePage(),
        '/login': (BuildContext context) => const LoginPage(),
        '/signup': (BuildContext context) => const SignupPage(),
        '/profile': (BuildContext context) => const ProfilePage(),
        '/': (BuildContext context) => const StartPage(),
      },
      theme: ThemeData.light(useMaterial3: true),
    );
  }
}
