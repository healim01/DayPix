import 'package:daypix/utils/notification.dart';
import 'package:daypix/screens/start.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'login.dart';
import 'home.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Timestamp? registeredDate;
  UserModel user = UserModel(email: '', uid: '', url: '', name: '');
  Duration? timeDifference;
  int? days;
  int? hours;
  int? minutes;
  String? formattedTimeDifference;
  String? formattedBeginDate;

  // timestamp 기준으로 Difference 구한 것
  // Duration calculateTimeDifference(Timestamp? registeredDate) {
  //   if (registeredDate != null) {
  //     DateTime now = DateTime.now();
  //     DateTime registeredDateTime = registeredDate.toDate();
  //     return now.difference(registeredDateTime);
  //   }
  //   return Duration.zero;
  // }

  // 날짜 기준으로 Difference 구한 것
  Duration calculateTimeDifference(Timestamp? registeredDate) {
    if (registeredDate != null) {
      DateTime now = DateTime.now();
      DateTime registeredDateTime = registeredDate.toDate();

      // Convert the dates to date-only format
      DateTime nowDateOnly = DateTime(now.year, now.month, now.day);
      DateTime registeredDateOnly = DateTime(registeredDateTime.year,
          registeredDateTime.month, registeredDateTime.day);

      return nowDateOnly.difference(registeredDateOnly);
    }
    return Duration.zero;
  }

  Future<void> readUserData(String uid) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('user')
          .where('uid', isEqualTo: uid)
          .get();

      if (snapshot.docs.isNotEmpty) {
        // 일치하는 문서가 있는 경우
        QueryDocumentSnapshot matchingDoc = snapshot.docs.first;
        Map<String, dynamic>? userData =
            matchingDoc.data() as Map<String, dynamic>?;
        // userData에서 필요한 필드를 추출
        String foundName = userData?['name'] ?? '';
        registeredDate = userData?['registeredDate'] ?? '';

        // 읽어온 데이터를 활용하여 user.name 업데이트
        setState(() {
          user.name = foundName;
        });
      } else {
        // 일치하는 문서가 없는 경우
        print('해당 UID에 대한 문서가 존재하지 않습니다.');
      }
    } catch (e) {
      // 읽기 도중 오류가 발생한 경우
      print('데이터를 읽어오는 중에 오류가 발생했습니다: $e');
    }
  }

  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      // 로그아웃이 성공적으로 수행될 경우, 로그인 페이지로 이동합니다.
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      print('로그아웃 중 오류가 발생했습니다: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // final UserModel user = ModalRoute.of(context)!.settings.arguments as UserModel;
    final UserModel routeUser =
        ModalRoute.of(context)!.settings.arguments as UserModel;
    user = routeUser; // routeUser를 user에 할당하여 초기값 설정
    // readUserData(user.uid);

    if (registeredDate == null) {
      readUserData(user.uid);
    }

    if (registeredDate != null) {
      timeDifference = calculateTimeDifference(registeredDate!);
      days = timeDifference!.inDays;
      hours = timeDifference!.inHours.remainder(24);
      minutes = timeDifference!.inMinutes.remainder(60);
      formattedTimeDifference = '${days}';
      formattedBeginDate = registeredDate != null
          ? DateFormat('yyyy.MM.dd').format(registeredDate!.toDate())
          : '';
    }

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.arrow_back,
                semanticLabel: 'arrow_back',
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            );
          },
        ),
        centerTitle: true,
        title: const Text('Profile'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        children: <Widget>[
          const SizedBox(height: 30.0),
          Container(
            width: 250,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  // fit: BoxFit.cover,
                  image: NetworkImage(user.url)),
            ),
          ),
          const SizedBox(height: 20.0),
          Text(
            user.name,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20.0),
          Text(
            user.email,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 15.0),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: const Divider(
              color: Color.fromRGBO(181, 181, 181, 1),
              height: 1,
            ),
          ),
          const SizedBox(height: 15.0),
          // Switch(
          //   // This bool value toggles the switch.
          //   value: light,
          //   activeColor: Colors.red,
          //   onChanged: (bool value) {
          //     print(value);
          //     // This is called when the user toggles the switch.
          //     setState(() {
          //       light = value;
          //       print(light);
          //     });
          //   },
          // ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Notification",
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(
                width: 10,
              ),
              SwitchExample(),
            ],
          ),
          // FlutterLocalNotification.showNotification();
          // child: const Text("알림 보내기"),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: Text(
                formattedBeginDate != null ? "${formattedBeginDate!}.~ing" : '',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: Text(
                formattedTimeDifference != null
                    ? "D+${formattedTimeDifference!}"
                    : '',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 280.0),
          Container(
            width: 80,
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: 130,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextButton(
                  onPressed: _logout,
                  child: const Text(
                    'LOG OUT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SwitchExample extends StatefulWidget {
  const SwitchExample({super.key});

  @override
  State<SwitchExample> createState() => _SwitchExampleState();
}

class _SwitchExampleState extends State<SwitchExample> {
  bool light = true;

  @override
  Widget build(BuildContext context) {
    return Switch(
      // This bool value toggles the switch.
      value: light,
      activeColor: Colors.blue,
      onChanged: (bool value) {
        setState(() {
          light = value;
          if (light == true) {
            FlutterLocalNotification.showNotification();
          }
        });
      },
    );
  }
}
