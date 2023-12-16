import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_tark/home.dart';
import 'package:hackathon_tark/phone.dart';
import 'package:hackathon_tark/route.dart';
import 'package:hackathon_tark/verify.dart';

import 'firebase_options.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // var launchService = LaunchService();
  runApp(MaterialApp(
    initialRoute: 'main',
    theme: ThemeData(fontFamily: 'Jura'),
    debugShowCheckedModeBanner: false,
    routes: {
      'phone': (context) => MyPhone(),
      'verify': (context) => MyVerify(),
      'home': (context) => MyHome(),
      'main': (context) => main_page(),

    },
  )
  );
}