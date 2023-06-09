import 'package:daypix/map.dart';
// import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daypix/detail.dart';
import 'package:daypix/notification.dart';
import 'package:daypix/profile.dart';
import 'package:daypix/search.dart';
import 'package:daypix/wrt_pic.dart';
import 'package:daypix/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:table_calendar/table_calendar.dart';

// TODO : uid 로 firebase열기

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime date = DateTime.now();
  CalendarFormat calendarFormat = CalendarFormat.month;
  DateTime? selectedDate = DateTime.now();

  int calculateDifference(DateTime date) {
    DateTime now = DateTime.now();
    return DateTime(date.year, date.month, date.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
  }

  @override
  void initState() {
    FlutterLocalNotification.init();

    // 3초 후 권한 요청
    Future.delayed(const Duration(seconds: 3),
        FlutterLocalNotification.requestNotificationPermission());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final UserModel user =
        ModalRoute.of(context)!.settings.arguments as UserModel;

    Future<void> _logout() async {
      try {
        await FirebaseAuth.instance.signOut();
        Navigator.pushReplacementNamed(context, '/');
      } catch (e) {
        print('로그아웃 중 오류가 발생했습니다: $e');
      }
    }

    Future<List<DocumentSnapshot>> getPostByDate(DateTime selectedDate) async {
      try {
        final String formattedDate =
            DateFormat('yy/MM/dd (E)').format(selectedDate);

        final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection(user.uid)
            .where('date', isEqualTo: formattedDate)
            .get();

        return querySnapshot.docs;
      } catch (e) {
        print('데이터 가져오기 중 오류가 발생했습니다: $e');
        return [];
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.menu,
                semanticLabel: 'menu',
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        centerTitle: true,
        title: const Text('Daypix'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.search,
              semanticLabel: 'search',
            ),
            onPressed: () {
              print('Search button');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchPage(),
                  settings: RouteSettings(
                    arguments: user,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfilePage(),
                  settings: RouteSettings(
                    arguments: user,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration:
                  BoxDecoration(color: Color.fromARGB(255, 33, 72, 148)),
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.0, 80.0, 16.0, 16.0),
                child: Text(
                  'DayPix',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              contentPadding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
              leading: const Icon(Icons.person,
                  color: Color.fromARGB(255, 33, 72, 148)),
              title: const Text('My Page'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfilePage(),
                    settings: RouteSettings(arguments: user),
                  ),
                );
              },
            ),
            ListTile(
              contentPadding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
              leading: const Icon(Icons.search,
                  color: Color.fromARGB(255, 33, 72, 148)),
              title: const Text('Search'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchPage(),
                    settings: RouteSettings(
                      arguments: user,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              contentPadding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
              leading: const Icon(Icons.map,
                  color: Color.fromARGB(255, 33, 72, 148)),
              title: const Text('Map'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MapPage(),
                      settings: RouteSettings(arguments: user),
                    ));
              },
            ),
            ListTile(
              contentPadding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
              leading: const Icon(Icons.logout,
                  color: Color.fromARGB(255, 33, 72, 148)),
              title: const Text('Log out'),
              onTap: () {
                _logout();
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: date,
            calendarFormat: calendarFormat,
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
            ),
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Color.fromARGB(255, 147, 195, 243),
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Color.fromARGB(255, 0, 55, 158),
                shape: BoxShape.circle,
              ),
              selectedTextStyle: TextStyle(
                color: Colors.white,
              ),
            ),
            selectedDayPredicate: (day) {
              return isSameDay(selectedDate, day);
            },
            onFormatChanged: (format) {
              setState(() {
                calendarFormat = format;
              });
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                selectedDate = selectedDay;
                date = focusedDay;
              });
            },
          ),
          if (selectedDate != null)
            FutureBuilder<List<DocumentSnapshot>>(
              future: getPostByDate(
                  selectedDate ?? date), // selectedDate가 null이면 date를 사용
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return const Text('데이터 가져오기 중 오류가 발생했습니다.');
                } else {
                  final documents = snapshot.data!;
                  if (documents.isEmpty) {
                    // 오늘이 아니면서 오늘 이후일 경우
                    if ((!selectedDate!.isBefore(DateTime.now())) &&
                        calculateDifference(selectedDate!) != 0) {
                      // if ((!selectedDate!.isBefore(DateTime.now()))) {
                      return Column(
                        children: [
                          const SizedBox(height: 50),
                          Center(
                            child: ClipOval(
                              child: Lottie.network(
                                'https://assets7.lottiefiles.com/packages/lf20_WWifl0Qmyq.json',
                                height: 200,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          const Text(
                            '미래 일기는 작성할 수 없어요~',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            '조금만 기다려주세요~',
                            style: TextStyle(
                              // fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      );
                    } else {
                      return Column(
                        children: [
                          const SizedBox(height: 30),
                          Center(
                            child: ClipOval(
                              child: Lottie.network(
                                'https://assets6.lottiefiles.com/temp/lf20_BnhDqb.json',
                                height: 200,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            '아직 다이어리가 없어요~ ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextButton(
                            onPressed: () {
                              String formatDate = selectedDate != null
                                  ? DateFormat('yy/MM/dd (E)')
                                      .format(selectedDate!)
                                  : DateFormat('yy/MM/dd (E)').format(date);

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      WrtPicPage(date: formatDate),
                                  settings: RouteSettings(arguments: user),
                                ),
                              );
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: const BorderSide(
                                      color: Color.fromARGB(255, 25, 158, 36),
                                      width: 2),
                                ),
                              ),
                            ),
                            child: const Text(
                              '지금 다이어리 쓰러 가기!',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Color.fromARGB(255, 25, 158, 36),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  } else {
                    // final data = documents[0].data() as Map<String, dynamic>;
                    final DocumentSnapshot document = documents[0];
                    final data = document.data() as Map<String, dynamic>;
                    final String docID = document.id; // 문서의 ID
                    final String img = data['img'];
                    final String text = data['text'];
                    final String emoji = data['emoji'];
                    final String date = data['date'];

                    return Stack(
                      children: [
                        InkWell(
                          onTap: () {
                            // TODO: 수정 필요
                            print("detail page let's go~");
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailPage(uID: user.uid, docID: docID),
                                settings: RouteSettings(arguments: user),
                              ),
                            );
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 350,
                            child: Image.network(
                              img,
                              fit: BoxFit.cover, // 이미지를 박스에 맞추기 위해 cover로 설정
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 20,
                          left: 20,
                          child: Text(
                            text,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Positioned(
                          top: 20,
                          right: 20,
                          child: Image.asset(
                            "assets/emoji/$emoji.png",
                            width: 40,
                            color: Colors.white,
                          ),
                        ),
                        Positioned(
                          top: 20,
                          left: 20,
                          child: Text(
                            date,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                }
              },
            ),
        ],
      ),
    );
  }
}
