import 'package:firebase_core/firebase_core.dart';
import 'package:daypix/widgets/app.dart';
import 'package:daypix/utils/firebase_options.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(ChangeNotifierProvider(
    builder: (context, child) => const DayPixApp(),
    create: (BuildContext context) {},
  ));
}
