import 'package:flutter/material.dart';

import 'package:daypix/home.dart';

class DayPixApp extends StatelessWidget {
  const DayPixApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DayPix',
      initialRoute: '/login',
      routes: {
        // '/login': (BuildContext context) => const LoginPage(),
        '/': (BuildContext context) => const HomePage(),
        // '/add': (BuildContext context) => const AddProduct(),
        // '/wish': (BuildContext context) => const WishProduct(),
        // // '/edit': (BuildContext context) => const EditProduct(proID: '',),
        // '/mypage': (BuildContext context) => const MyPage(),
      },
      theme: ThemeData.light(useMaterial3: true),
    );
  }
}
