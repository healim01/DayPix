import 'package:daypix/map.dart';
import 'package:daypix/profile.dart';
import 'package:daypix/wrt_pic.dart';
import 'package:daypix/login.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime date = DateTime.now();
  String formatDate = '';

  @override
  Widget build(BuildContext context) {
    final UserModel user =
        ModalRoute.of(context)!.settings.arguments as UserModel;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.person),
          onPressed: () {
            if (user != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfilePage(),
                  settings: RouteSettings(arguments: user),
                ),
              );
            }
          },
        ),
        title: const Text("DayPix"),
        actions: [
          IconButton(
              onPressed: () {
                print(("object"));
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MapPage(uid: user.uid),
                    ));
              },
              icon: const Icon(Icons.map))
        ],
      ),
      body: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.calendar_month),
              const SizedBox(width: 5),
              const Text("check-in"),
              const SizedBox(width: 80),
              ElevatedButton(
                onPressed: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: date,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2040),
                  );
                  if (selectedDate != null) {
                    setState(
                      () {
                        date = selectedDate;
                        formatDate = DateFormat('yy/MM/dd (E)').format(date);
                      },
                    );
                  }
                },
                child: const Text("select date"),
              )
            ],
          ),
          Text(formatDate),
          TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WrtPicPage(date: formatDate)),
                );
              },
              child: const Text("Writing Pic Page"))
        ],
      ),
    );
  }
}
