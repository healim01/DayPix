import 'package:daypix/start.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final UserModel user = ModalRoute.of(context)!.settings.arguments as UserModel;
    return Scaffold(
      appBar: AppBar(
        title: Text("DayPix"),
        leading: IconButton(
          icon: Icon(Icons.person),
          onPressed: () {
            if (user != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(),
                  settings: RouteSettings(
                    arguments: user
                  ),
                ),
              );
            }
          },
        ),
      ),
      body: Column(
        children: [
          TextButton(
            child: const Text('Go to Start Page'),
            onPressed: () {
              Navigator.pushNamed(context, '/');
            },
          ),
          if (user != null) Text(user.uid ?? ""),
        ],
      ),
    );
  }
}
