import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_tark/presentation/route.dart';

import 'presentation/home.dart';
import 'presentation/phone.dart';
import 'presentation/verify.dart';

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