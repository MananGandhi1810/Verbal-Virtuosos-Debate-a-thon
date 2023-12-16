import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_tark/presentation/edit_details.dart';
import 'package:hackathon_tark/presentation/register_user_info.dart';
import 'package:hackathon_tark/presentation/route.dart';

import 'firebase_options.dart';
import 'presentation/add_project.dart';
import 'presentation/home.dart';
import 'presentation/phone.dart';
import 'presentation/profile.dart';
import 'presentation/project_details.dart';
import 'presentation/verify.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // var launchService = LaunchService();
  runApp(
    MaterialApp(

      initialRoute: 'main',
      theme: ThemeData(fontFamily: 'Jura', useMaterial3: true),
      debugShowCheckedModeBanner: false,
      routes: {
        'phone': (context) => const MyPhone(),
        'verify': (context) => const MyVerify(),
        'home': (context) => const MyHome(),
        'main': (context) => const main_page(),
        'add_project': (context) => const AddProject(),
        'user_info_registration': (context) => const RegisterUserInfo(),
        'profile': (context) => Profile(
              uid: ModalRoute.of(context)!.settings.arguments as String,
            ),
        "project_details": (context) => ProjectDetails(
          project: ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>,
        ),
        "edit_details": (context) => EditDetails(
          userDetails: ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>,
        ),
      },
    ),
  );
}
