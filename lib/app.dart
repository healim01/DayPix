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
      initialRoute: '/home',
      routes: {
        // '/login': (BuildContext context) => const LoginPage(),
        '/home': (BuildContext context) => const HomePage(),
        // '/add': (BuildContext context) => const AddProduct(),
        // '/wish': (BuildContext context) => const WishProduct(),
        // // '/edit': (BuildContext context) => const EditProduct(proID: '',),
        // '/mypage': (BuildContext context) => const MyPage(),
        '/login': (BuildContext context) => const LoginPage(), 
        '/signup': (BuildContext context) => const SignupPage(),
        '/profile': (BuildContext context) => const ProfilePage(),   
        '/': (BuildContext context) => const StartPage(),  
      },
      theme: ThemeData.light(useMaterial3: true),
    );
  }
}
